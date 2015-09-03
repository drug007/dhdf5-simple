module dhdf5.dataset;

import std.conv: castFrom;
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
}

struct Dataset(Data)
{
    private
    {
        alias DataSpecType = typeof(DataSpecification!Data.make());

        this(hid_t dataset, DataSpecType data_spec)
        {
            _dataset = dataset;
            _data_spec = data_spec;
        }
    }

    enum DEFAULT_CHUNK_SIZE = 512;

    static create(ref const(H5File) file, string name)
    {
        auto dcpl_id = H5P_DEFAULT;

        static if(isStaticArray!Data)
        {
            auto curr_dim = countDimensions!(Data);
            auto max_dim = curr_dim;
        }
        else
        static if(isDynamicArray!Data)
        {
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
        }
        else
        {
            enum LENGTH = 1;
            hsize_t[1] curr_dim = [ LENGTH ];
            auto max_dim = curr_dim;
        }
        
        auto space = H5Screate_simple(castFrom!(size_t).to!int(curr_dim.length), curr_dim.ptr, max_dim.ptr);
        auto data_spec = DataSpecification!Data.make();
        auto dataset = H5Dcreate2(file.tid, name.ptr, data_spec.tid, space, H5P_DEFAULT, dcpl_id, H5P_DEFAULT);
        assert(dataset >= 0);
        return Dataset!Data(dataset, data_spec);
    }

    static open(ref const(H5File) file, string name)
    {
        auto data_spec = DataSpecification!Data.make();
        auto dataset = H5Dopen2(file.tid, name.ptr, H5P_DEFAULT);
        assert(dataset >= 0);
        return Dataset!Data(dataset, data_spec);
    }

    /*
     * Wtite data to the dataset; 
     */ 
    auto write(ref Data data)
    {
        /*
         * Select a hyperslab.
         */
        auto filespace = H5Dget_space (_dataset);
        auto rank      = H5Sget_simple_extent_ndims(filespace);

        hsize_t[] dims, offset;
        offset.length = rank;
        offset[] = 0;
        dims.length   = rank;
        auto status = H5Sget_simple_extent_dims(filespace, dims.ptr, null);
        assert(status >= 0);

        static if(isDynamicArray!Data)
        {
            /*
             * Extend the dataset.
             */
            auto size = countDimensions(data);
            status = H5Dset_extent (_dataset, size.ptr);
            assert(status >= 0);
            auto data_in = data.ptr;
        }
        else
        {
            auto data_in = &data;
        }

        status = H5Sselect_hyperslab(filespace, H5S_seloper_t.H5S_SELECT_SET, offset.ptr, null,
                     dims.ptr, null);
        status = H5Dwrite(_dataset, _data_spec.tid, H5S_ALL, H5S_ALL, H5P_DEFAULT, data_in);
        assert(status >= 0);
    }

    /*
     * Read data from the dataset.
     */
    auto read(ref Data data)
    {
        auto filespace = H5Dget_space(_dataset);    /* Get filespace handle first. */
        auto rank      = H5Sget_simple_extent_ndims(filespace);

        hsize_t[] dims;
        dims.length = rank;
        auto status = H5Sget_simple_extent_dims(filespace, dims.ptr, null);
        assert(status >= 0);

        static if(isDynamicArray!Data)
        {
            setDynArrayDimensions(data, dims);
            auto data_out = data.ptr;
        }
        else
        {
            auto data_out = &data;
        }
        /*
         * Define the memory space to read dataset.
         */
        auto memspace = H5Screate_simple(castFrom!size_t.to!int(dims.length), dims.ptr, null);
     
        /*
         * Read dataset back and display.
         */
        status = H5Dread(_dataset, _data_spec.tid, memspace, filespace,
                 H5P_DEFAULT, data_out);
        assert(status >= 0);
    }

    ~this()
    {
        auto space = H5Dget_space(_dataset);
        H5Sclose(space);
        H5Dclose(_dataset);
    }

private:
    hid_t _dataset;
    DataSpecType _data_spec;
}
