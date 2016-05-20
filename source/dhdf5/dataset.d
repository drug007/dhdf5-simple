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
}

struct Dataset(Data)
{
    private
    {
        alias DataSpecType = typeof(DataSpecification!Data.make());

        bool _inited;

        this(hid_t dataset, DataSpecType data_spec)
        {
            _dataset = dataset;
            _data_spec = data_spec;
            _inited = true; // TODO would be better to use native hdf5 means to detect if resources are freed
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
        auto dataset = H5Dcreate2(file.tid, name.toStringz, data_spec.tid, space, H5P_DEFAULT, dcpl_id, H5P_DEFAULT);
        assert(dataset >= 0);
        return Dataset!Data(dataset, data_spec);
    }

    static open(ref const(H5File) file, string name)
    {
        auto data_spec = DataSpecification!Data.make();
        auto dataset = H5Dopen2(file.tid, name.toStringz, H5P_DEFAULT);
        assert(dataset >= 0);
        return Dataset!Data(dataset, data_spec);
    }

    /**
     * Return rank of the dataset
     */
    auto rank()
    {
        auto space_id = H5Dget_space (_dataset);
        assert(space_id >= 0);
        return H5Sget_simple_extent_ndims(space_id);
    }

    /**
     * Return current and maximum size by dimensions.
     */
    auto dimensions()
    {
        import std.typecons: tuple;

        auto curr_dims = new hsize_t[rank];
        auto max_dims  = new hsize_t[rank];
        auto space_id  = H5Dget_space (_dataset);
        assert(space_id >= 0);
        H5Sget_simple_extent_dims(space_id, curr_dims.ptr, max_dims.ptr);

        return tuple(curr_dims, max_dims);
    }

    /**
     * Read count data from file starting with offset 
     */
    auto read(hsize_t offset, hsize_t count)
    {
        const max_size = dimensions[1][0];
        assert((offset+count) <= max_size);
        /*
        * get the file dataspace.
        */
        auto dataspace = H5Dget_space(_dataset); // dataspace identifier
        assert(dataspace >= 0);
        scope(exit) H5Sclose(dataspace);
        
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
        static if(isDynamicArray!Data)
        {
            setDynArrayDimensions(data, [count]);
            auto data_out = data.ptr;
        }
        else
        {
            auto data_out = &data;
        }
        
        status = H5Dread(_dataset, _data_spec.tid, memspace, dataspace, H5P_DEFAULT, data_out);
        assert(status >= 0);
        return data;
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
        assert(filespace >= 0);
        scope(exit) H5Sclose(filespace);
        
        // get current size
        auto dims = dimensions[0];
        // set offset to zero for all dimensions
        auto offset = dims.dup;
        offset[] = 0;
        herr_t status;

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
        assert(status >= 0);
        status = H5Dwrite(_dataset, _data_spec.tid, H5S_ALL, H5S_ALL, H5P_DEFAULT, data_in);
        assert(status >= 0);
    }

    /*
     * Read data from the dataset.
     */
    auto read()
    {
        Data data;
        auto filespace = H5Dget_space(_dataset);    /* Get filespace handle first. */
        assert(filespace >= 0);
        scope(exit) H5Sclose(filespace);
        
        // get current size
        auto dims = dimensions[0];
        // set offset to zero for all dimensions
        auto offset = dims.dup;
        offset[] = 0;
        herr_t status;

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
        scope(exit) H5Sclose(memspace);
     
        /*
         * Read dataset
         */
        status = H5Dread(_dataset, _data_spec.tid, memspace, filespace,
                 H5P_DEFAULT, data_out);
        assert(status >= 0);

        return data;
    }

    void close()
    {
        if(!_inited)
            return;

        scope(success) _inited = false;

        assert(_dataset >= 0);
        auto space = H5Dget_space(_dataset);
        assert(space >= 0);
        H5Sclose(space);
        H5Dclose(_dataset);
    }

    ~this()
    {
        close();
    }

private:
    hid_t _dataset = -1;
    DataSpecType _data_spec;
}
