module dhdf5.dataset;

import hdf5.hdf5;

import dhdf5.file;
import dhdf5.dataspace;
import dhdf5.dataspec;

struct Dataset(Data)
{
    this(DataSpace)(ref const(H5File) file, string name, ref const(DataSpace) space)
    {
        _data_spec = DataSpecification!Data.make();
        _dataset = H5Dcreate2(file.tid, name.ptr, _data_spec.tid, space.tid, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
        assert(_dataset >= 0);
    }

    this(ref const(H5File) file, string name)
    {
        _data_spec = DataSpecification!Data.make();
        _dataset = H5Dopen2(file.tid, name.ptr, H5P_DEFAULT);
        assert(_dataset >= 0);
    }

    /*
     * Wtite data to the dataset; 
     */ 
    auto write(ref Data data)
    {
        auto status = H5Dwrite(_dataset, _data_spec.tid, H5S_ALL, H5S_ALL, H5P_DEFAULT, &data);
        assert(status >= 0);
    }

    /*
     * Read data from the dataset.
     */
    auto read(ref Data data)
    {
        auto status = H5Dread(_dataset, _data_spec.tid, H5S_ALL, H5S_ALL, H5P_DEFAULT, &data);
        assert(status >= 0);
    }

    ~this()
    {
        H5Dclose(_dataset);
    }

private:
    hid_t _dataset;
    DataSpecification!Data _data_spec;
}
