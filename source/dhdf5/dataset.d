module dhdf5.dataset;

import std.conv: castFrom;
import std.string: toStringz;
import std.traits;

import hdf5.hdf5;

import dhdf5.file;
import dhdf5.dataspec;


private
{
	/// array is dynamic array whose dimensions sizes are set using dim array elements
	/// as sizes.
	auto setDynArrayDimensions(T)(ref T arr, size_t[] dim) if(isDynamicArray!T)
	{
		auto setDimImpl(T)(ref T t, size_t[] dim)
		{
			static if(isDynamicArray!T)
			{
				static if(isDynamicArray!(typeof(t[0])))
				{
					t.length = dim[0];
					foreach(ref e; t[0..$])
					{
						e.length = dim[1];
					}

					return setDimImpl(t[0], dim[1..$]);
				}
				else
				{
					t.length = dim[0];
				}
			}

		}

		return setDimImpl(arr, dim);
	}

	unittest
	{
		size_t[] dim = [1, 3, 5];
		int[][][] res;
		setDynArrayDimensions(res, dim);
		assert(res.length == 1);
		assert(res[0].length == 3);
		assert(res[0][0].length == 5);

		int[] res2;
		setDynArrayDimensions(res2, dim);
		assert(res2.length == 1);
	}

	struct Dataspace
	{
		hid_t hid;

		this(hid_t dataset)
		{
			hid = H5Dget_space (dataset);
			assert(hid >= 0);
		}

		~this()
		{
			H5Sclose (hid);
		}

		alias hid this;
	}
}

struct Dataset(Data, DataSpecType)
{
	static assert (isDynamicArray!Data, Data.stringof ~ " should be dynamic array type");

	private
	{
		this(hid_t dataset, DataSpecType data_spec)
		{
			_dataset = dataset;
			_data_spec = data_spec;

			auto space_id = Dataspace (_dataset);
			_rank = H5Sget_simple_extent_ndims(space_id);
			_curr_shape.length = _rank;
			_max_shape.length = _rank;
		}

		~this()
		{
			H5Dclose(_dataset);
		}
	}

	static create(ref const(H5File) file, string name)
	{
		enum DEFAULT_CHUNK_SIZE = 512;
		auto dcpl_id = H5P_DEFAULT;

		/* Create a dataset creation property list and set it to use chunking
		 */
		auto max_dim = countDimensions!(Data)();
		auto curr_dim = max_dim.dup;
		curr_dim[] = 0;
		hsize_t[] chunk_dims;
		chunk_dims.length = curr_dim.length;
		chunk_dims[] = DEFAULT_CHUNK_SIZE;
		dcpl_id = H5Pcreate(H5P_DATASET_CREATE);
		scope(exit) H5Pclose(dcpl_id);

		H5Pset_chunk(dcpl_id, castFrom!size_t.to!int(chunk_dims.length), chunk_dims.ptr);

		auto space = H5Screate_simple(castFrom!(size_t).to!int(curr_dim.length), curr_dim.ptr, max_dim.ptr);
		auto data_spec = DataSpecType.make();
		auto dataset = H5Dcreate2(file.tid, name.toStringz, data_spec.tid, space, H5P_DEFAULT, dcpl_id, H5P_DEFAULT);
		assert(dataset >= 0);
		return Dataset!(Data, DataSpecType)(dataset, data_spec);
	}

	static open(ref const(H5File) file, string name)
	{
		auto data_spec = DataSpecType.make();
		auto dataset = H5Dopen2(file.tid, name.toStringz, H5P_DEFAULT);
		assert(dataset >= 0);
		return Dataset!(Data, DataSpecType)(dataset, data_spec);
	}

	/**
	 * Return rank of the dataset
	 */
	auto rank()
	{
		return _rank;
	}

	/**
	 * Return current shape, that can change during programm running.
	 */
	auto currShape()
	{
		import std.typecons: tuple;

		auto space_id  = Dataspace (_dataset);

		H5Sget_simple_extent_dims(space_id, _curr_shape.ptr, _max_shape.ptr);

		return _curr_shape[];
	}

	/**
	 * Return maximal shape, that doesn't change during program running.
	 */
	auto maxShape() const pure
	{
		return _max_shape[];
	}

	/**
	 * Read count data from file starting with offset
	 */
	auto read(hsize_t offset, hsize_t count)
	{
		assert((offset+count) <= _max_shape[0]);
		/*
		* get the file dataspace.
		*/
		auto dataspace = Dataspace (_dataset); // dataspace identifier

		auto file_offset = [offset];
		auto file_count  = [count];
		auto status = H5Sselect_hyperslab(dataspace, H5S_seloper_t.H5S_SELECT_SET, file_offset.ptr, null, file_count.ptr, null);
		assert(status >= 0);
		/*
		* Define memory dataspace.
		*/
		auto mem_offset = [0UL];
		auto mem_count  = [count];
		auto dimsm = mem_count;
		auto memspace = H5Screate_simple(rank, dimsm.ptr, null);
		scope(exit) H5Sclose(memspace);

		/*
		* Define memory hyperslab.
		*/
		status = H5Sselect_hyperslab(memspace, H5S_seloper_t.H5S_SELECT_SET, mem_offset.ptr, null, mem_count.ptr, null);
		assert(status >=0);

		Data data;
		setDynArrayDimensions(data, [count]);

		status = H5Dread(_dataset, _data_spec.tid, memspace, dataspace, H5P_DEFAULT, data.ptr);
		assert(status >= 0);
		return data;
	}

	/*
	 * Wtite data to the dataset;
	 */
	auto write(ref Data data)
	{
		/*
		 * Make a copy of dataspace of the dataset.
		 */
		auto filespace = Dataspace (_dataset);

		// get copy of the current shape
		auto offset = currShape().dup;
		// set offset to zero for all dimensions
		offset[] = 0;
		herr_t status;

		/*
		 * Extend the dataset.
		 */
		auto size = countDimensions(data);
		status = H5Dset_extent (_dataset, size.ptr);
		assert(status >= 0);

		status = H5Sselect_hyperslab(filespace, H5S_seloper_t.H5S_SELECT_SET, offset.ptr, null,
					 currShape().ptr, null);
		assert(status >= 0);
		status = H5Dwrite(_dataset, _data_spec.tid, H5S_ALL, H5S_ALL, H5P_DEFAULT, data.ptr);
		assert(status >= 0);
	}

	/*
	 * Wtite data to the dataset;
	 */
	auto write(Data data, hsize_t[] offset)
	{
		assert(offset.length == _rank);
		hsize_t[] count = [data.length];
		assert(  count.length == _rank);
		herr_t status;

		auto filespace = Dataspace (_dataset);
		status = H5Sselect_hyperslab(filespace, H5S_seloper_t.H5S_SELECT_SET, offset.ptr, null, count.ptr, null);
		assert(status >= 0);

		auto memspace = H5Screate_simple(rank, count.ptr, null);
		scope(exit) H5Sclose(memspace);

		status = H5Dwrite(_dataset, _data_spec.tid, memspace, filespace, H5P_DEFAULT, data.ptr);
		assert(status >= 0);
	}

	auto setShape(hsize_t[] extent)
	{
		auto status = H5Dset_extent (_dataset, extent.ptr);
		assert(status >= 0);
	}

	/*
	 * Read data from the dataset.
	 */
	auto read()
	{
		Data data;
		auto filespace = Dataspace(_dataset);

		// get current size
		auto offset = currShape().dup;
		// set offset to zero for all dimensions
		offset[] = 0;
		herr_t status;

		setDynArrayDimensions(data, currShape());
		/*
		 * Define the memory space to read dataset.
		 */
		auto memspace = H5Screate_simple(_rank, currShape().ptr, null);
		scope(exit) H5Sclose(memspace);

		/*
		 * Read dataset
		 */
		status = H5Dread(_dataset, _data_spec.tid, memspace, filespace,
				 H5P_DEFAULT, data.ptr);
		assert(status >= 0);

		return data;
	}

private:
	hid_t _dataset;
	DataSpecType _data_spec;
	immutable int _rank;
	// Current shape of dataset
	hsize_t[] _curr_shape;
	// Maximal shape of dataset
	hsize_t[] _max_shape;
}
