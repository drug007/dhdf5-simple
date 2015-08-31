module dhdf5.file;

import hdf5.hdf5;

struct H5File
{
    @disable this();

    enum Access
    {
        ReadOnly  = H5F_ACC_RDONLY, /*absence of rdwr => rd-only */
        ReadWrite = H5F_ACC_RDWR,   /*open for read and write    */
        Trunc     = H5F_ACC_TRUNC,  /*overwrite existing files   */
        Exclude   = H5F_ACC_EXCL,   /*fail if file already exists*/
        Debug     = H5F_ACC_DEBUG,  /*print debug info           */
        Create    = H5F_ACC_CREAT,  /*create non-existing files  */
    };

    this(string filename, uint flags, hid_t fapl_id = H5P_DEFAULT, hid_t fcpl_id = H5P_DEFAULT)
    {
        // remove Access.Debug flag if any
        auto f = flags & ~Access.Debug;
        if(((f == Access.Trunc) && (f != Access.Exclude)) ||
           ((f != Access.Trunc) && (f == Access.Exclude)))
        {
            _file = H5Fcreate(filename.ptr, flags, fcpl_id, fapl_id);
            assert(_file >= 0);
        }
        else
        if(((f == Access.ReadOnly) && (f != Access.ReadWrite)) ||
           ((f != Access.ReadOnly) && (f == Access.ReadWrite)))
        {
            _file = H5Fopen(filename.ptr, flags, fapl_id);
            assert(_file >= 0);
        }
        else
            assert(0, "Unknown flags combination.");
    }

    ~this()
    {
        /*
         * Release resources
         */
        H5Fclose(_file);
    }

    const tid() const pure @safe
    {
    	return _file;
    }

private:
    hid_t _file;
}
