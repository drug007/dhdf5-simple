module dhdf5.dataset;

import hdf5.hdf5;

import dhdf5.file;
import dhdf5.dataspace;
import dhdf5.dataspec;

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

    static create(ref const(H5File) file, string name)
    {
        enum LENGTH = 1;
        hsize_t[1] dim = [ LENGTH ];
        auto space = DataSpace!(Data)(dim);
        auto data_spec = DataSpecification!Data.make();
        auto dataset = H5Dcreate2(file.tid, name.ptr, data_spec.tid, space.tid, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
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
    DataSpecType _data_spec;
}
