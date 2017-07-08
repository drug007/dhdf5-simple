module dhdf5.file;

import std.string: toStringz;

import hdf5.hdf5;

struct H5File
{
	enum Access
	{
		ReadOnly  = H5F_ACC_RDONLY, /*absence of rdwr => rd-only */
		ReadWrite = H5F_ACC_RDWR,   /*open for read and write    */
		Trunc     = H5F_ACC_TRUNC,  /*overwrite existing files   */
		Exclude   = H5F_ACC_EXCL,   /*fail if file already exists*/
		Create    = H5F_ACC_CREAT,  /*create non-existing files  */
	};

	this(string filename, Access mode, hid_t fapl_id = H5P_DEFAULT, hid_t fcpl_id = H5P_DEFAULT)
	{
		final switch(mode)
		{
			case Access.Trunc:
			case Access.Exclude:
			{
				_file = H5Fcreate(filename.toStringz, mode, fcpl_id, fapl_id);
				break;
			}
			case Access.ReadOnly:
			case Access.ReadWrite:
			{
				_file = H5Fopen(filename.toStringz, mode, fapl_id);
				break;
			}
			case Access.Create:
				assert (0, "Flag H5F_ACC_CREAT is not supported.");
		}
		assert(_file >= 0);
	}

	~this()
	{
		if (_file != -1)
		{
			H5Fclose(_file);
			_file = -1;
		}
	}

	auto tid() const pure @safe
	{
		return _file;
	}

private:
	hid_t _file = -1;
}
