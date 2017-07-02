module dhdf5.dataset;

private
{
	import std.traits : isDynamicArray;
	import std.range : isInputRange;
	import dhdf5.dataspec : DataSpecification;

	/// array is dynamic array whose dimensions sizes are set using dim array elements
	/// as sizes.
	auto setDynArrayDimensions(T)(ref T arr, const size_t[] dim) if(isDynamicArray!T)
	{
		auto setDimImpl(T)(ref T t, const size_t[] dim)
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

	template rankOf(R)
		if (isInputRange!R)
	{
		auto rankOfImpl(Range)()
		{
			import std.range : ElementType;

			static if (isInputRange!Range)
			{
				return 1 + rankOfImpl!(ElementType!Range);
			}
			else
				return 0;
		}

		enum rankOf = rankOfImpl!R;
	}

	unittest
	{
		{
			enum rank = rankOf!(uint[]);
			static assert (rank == 1);
		}

		{
			enum rank = rankOf!(uint[][][][][][]);
			static assert (rank == 6);
		}

		{
			import std.range : only;

			auto range = only(1, 2);
			alias Range = typeof(range);

			enum rank = rankOf!Range;
			static assert (rank == 1);
		}

		{
			import std.range : only;

			auto range = only(1, 2);
			alias Range = typeof(range);

			auto ror = only(range, range);
			alias RoR = typeof(ror);

			enum rank = rankOf!RoR;
			static assert (rank == 2);
		}
	}

	struct Dataspace
	{
		import hdf5.hdf5 : hid_t, H5Dget_space, H5Sclose;

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

struct Dataset(Data, DataSpecType = typeof(DataSpecification!Data.make()))
	if (isInputRange!Data)
{
	import std.range : ElementType, hasLength;
	import hdf5.hdf5 : hid_t, hsize_t, H5Sget_simple_extent_ndims, H5Dclose;
	import dhdf5.file : H5File;

	static assert (isInputRange!Data, Data.stringof ~ " should be input range");

	enum rank = rankOf!Data;

	private
	{
		this(hid_t dataset, DataSpecType data_spec)
		{
			_dataset = dataset;
			_data_spec = data_spec;

			debug
			{
				import hdf5.hdf5 : H5Sget_simple_extent_ndims;

				auto space_id = Dataspace (_dataset);
				assert (rank == H5Sget_simple_extent_ndims (space_id));
			}
		}

		~this()
		{
			import hdf5.hdf5 : H5Dclose;

			H5Dclose(_dataset);
		}
	}

	static create(ref const(H5File) file, string name)
	{
		import std.string: toStringz;
		import hdf5.hdf5 : H5P_DEFAULT, H5P_DATASET_CREATE, H5Pcreate, H5Pclose,
			H5Pset_chunk, H5Screate_simple, H5Dcreate2;
		import dhdf5.dataspec : countDimensions;
		import std.conv: castFrom;

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
		dcpl_id = H5Pcreate (H5P_DATASET_CREATE);
		scope(exit) H5Pclose (dcpl_id);

		H5Pset_chunk (dcpl_id, castFrom!size_t.to!int(chunk_dims.length), chunk_dims.ptr);

		auto space = H5Screate_simple (castFrom!(size_t).to!int(curr_dim.length), curr_dim.ptr, max_dim.ptr);
		auto data_spec = DataSpecType.make();
		auto dataset = H5Dcreate2 (file.tid, name.toStringz, data_spec.tid, space, H5P_DEFAULT, dcpl_id, H5P_DEFAULT);
		assert(dataset >= 0);
		return Dataset!(Data, DataSpecType)(dataset, data_spec);
	}

	static open(ref const(H5File) file, string name)
	{
		import std.string: toStringz;
		import hdf5.hdf5 : H5P_DEFAULT, H5Dopen2;

		auto data_spec = DataSpecType.make();
		auto dataset = H5Dopen2 (file.tid, name.toStringz, H5P_DEFAULT);
		assert(dataset >= 0);
		return Dataset!(Data, DataSpecType)(dataset, data_spec);
	}

	/**
	 * Return current shape, that can change during programm running.
	 */
	auto currShape() const
	{
		import hdf5.hdf5 : H5Sget_simple_extent_dims;

		auto space_id  = Dataspace (_dataset);

		H5Sget_simple_extent_dims (space_id, _curr_shape.ptr, _max_shape.ptr);

		return _curr_shape;
	}

	auto currShape(hsize_t[] extent)
	{
		import hdf5.hdf5;

		auto status = H5Dset_extent (_dataset, extent.ptr);
		assert(status >= 0);
	}

	/**
	 * Return maximal shape, that doesn't change during program running.
	 */
	auto maxShape() const pure
	{
		return _max_shape;
	}

	/*
	 * Read data from the dataset.
	 */
	auto read() const
	{
		import hdf5.hdf5;

		ElementType!Data[] data;
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
		auto memspace = H5Screate_simple(rank, currShape().ptr, null);
		scope(exit) H5Sclose(memspace);

		/*
		 * Read dataset
		 */
		status = H5Dread(_dataset, _data_spec.tid, memspace, filespace,
				 H5P_DEFAULT, data.ptr);
		assert(status >= 0);

		return data;
	}

	/**
	 * Read count data from file starting with offset
	 */
	auto read(hsize_t[] offset, hsize_t[] count) const
	{
		import hdf5.hdf5 : H5Sselect_hyperslab, H5Screate_simple, H5Dread, H5Sclose,
			H5S_seloper_t, H5P_DEFAULT;

		//assert((offset+count) <= _max_shape[0]);
		/*
		* get the file dataspace.
		*/
		auto dataspace = Dataspace (_dataset); // dataspace identifier

		auto status = H5Sselect_hyperslab (dataspace, H5S_seloper_t.H5S_SELECT_SET, offset.ptr, null, count.ptr, null);
		assert(status >= 0);
		/*
		* Define memory dataspace.
		*/
		auto mem_offset = offset;
		mem_offset[] = 0;
		auto mem_count  = count;
		auto dimsm = mem_count;
		auto memspace = H5Screate_simple (rank, dimsm.ptr, null);
		scope(exit) H5Sclose (memspace);

		/*
		* Define memory hyperslab.
		*/
		status = H5Sselect_hyperslab (memspace, H5S_seloper_t.H5S_SELECT_SET, mem_offset.ptr, null, mem_count.ptr, null);
		assert(status >=0);

		ElementType!Data[] data;
		setDynArrayDimensions (data, count);

		status = H5Dread (_dataset, _data_spec.tid, memspace, dataspace, H5P_DEFAULT, data.ptr);
		assert(status >= 0);
		return data;
	}

	/*
	 * Write data to the dataset
	 */
	auto write(ElementType!Data[] data)
	{
		hsize_t[rank] offset;
		offset[] = 0;
		write(data, offset[]);
	}

	/*
	 * Write data to the dataset;
	 */
	auto write(ElementType!Data[] data, const(hsize_t)[] offset)
	{
		import std.exception : enforce;
		enforce (data.length+offset[0] <= currShape[0], "Bounds checking failed!");

		import hdf5.hdf5 : herr_t, H5Sselect_hyperslab, H5Screate_simple, H5Dwrite,
			H5S_seloper_t, H5P_DEFAULT, H5Sclose;

		assert(offset.length == rank);
		hsize_t[rank] count = [data.length];
		assert(  count.length == rank);
		herr_t status;

		auto filespace = Dataspace (_dataset);
		status = H5Sselect_hyperslab (filespace, H5S_seloper_t.H5S_SELECT_SET, offset.ptr, null, count.ptr, null);
		assert(status >= 0);

		auto memspace = H5Screate_simple (rank, count.ptr, null);
		scope(exit) H5Sclose (memspace);

		status = H5Dwrite (_dataset, _data_spec.tid, memspace, filespace, H5P_DEFAULT, data.ptr);
		assert(status >= 0);
	}

	auto remove(hsize_t idx)
	{
		auto l = currShape[0];
		if (idx != l-1)
		{
			auto buffer = read([idx+1], [currShape[0]-idx-1]);
			write(buffer, [idx]);
		}
		currShape = [l - 1];
	}

	auto remove(IndexRange)(IndexRange index_range)
	{

	}

	Range opSlice()
	{
		return Range(this, 0, currShape[0]);
	}

	auto add(ElementType!Data element)
	{
		// set new shape
		auto last_index = currShape[0];
		currShape = [last_index+1];
		write([element], [last_index]);
	}

	auto add(Range)(Range range)
		if (is(ElementType!Range : ElementType!Data) && hasLength!Range)
	{
		// set new shape
		auto last_index = currShape[0];
		currShape = [last_index+range.length];
		write(range, [last_index]);
	}

	struct Range
	{
		// index of starting element + element count of the range
		private
		{
			size_t _start, _length;
			Dataset* _dataset;
		}

		@disable
		this();

		this(ref Dataset dataset, size_t start, size_t length)
		{
			_dataset = &dataset;
			_start = start;
			_length = length;
		}

		bool empty() const
		{
			return _length == 0;
		}

		ref ElementType!Data front() const
		{
			return (*_dataset)[_start];
		}

		ref ElementType!Data back() const
		{
			return (*_dataset)[_start+_length-1];
		}

		void popFront()
		{
			import std.exception : enforce;

			enforce (!empty);

			_start++;
			_length--;
		}

		void popBack()
		{
			import std.exception : enforce;

			enforce (!empty);

			_length--;
		}

		auto save() const
		{
			return this;
		}

		ref auto opIndex(size_t index) const
		{
			return (*_dataset)[index];
		}

		size_t length() const
		{
			return _length;
		}
	}

	ref ElementType!Data opIndex(size_t index) const
	{
		if (index >= currShape[0])
			throw new Exception("Bounds");

		return read([index], [1])[0];
	}

	auto opIndexAssign(ElementType!Data element, size_t index)
	{
		write([element], [index]);
	}

	auto opOpAssign(string op)(ElementType!Data rhs)
	{
		static if (op == "~")
		{
			add(rhs);
		}
	}

	auto opOpAssign(string op, Range)(Range r)
	{
		static if (op == "~")
		{
			add(r);
		}
	}

private:
	hid_t _dataset;
	DataSpecType _data_spec;
	// Current shape of dataset
	hsize_t[rank] _curr_shape;
	// Maximal shape of dataset
	hsize_t[rank] _max_shape;
}
