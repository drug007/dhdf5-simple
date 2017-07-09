module hdf5.H5Ipublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;

extern (C):

//alias H5I_type_t H5I_type_t;
alias c_long hid_t;
alias int function (void*) H5I_free_t;
alias int function (void*, c_long, void*) H5I_search_func_t;

enum H5I_type_t
{
    H5I_UNINIT = -2,
    H5I_BADID = -1,
    H5I_FILE = 1,
    H5I_GROUP = 2,
    H5I_DATATYPE = 3,
    H5I_DATASPACE = 4,
    H5I_DATASET = 5,
    H5I_ATTR = 6,
    H5I_REFERENCE = 7,
    H5I_VFL = 8,
    H5I_GENPROP_CLS = 9,
    H5I_GENPROP_LST = 10,
    H5I_ERROR_CLASS = 11,
    H5I_ERROR_MSG = 12,
    H5I_ERROR_STACK = 13,
    H5I_NTYPES = 14
}

hid_t H5Iregister (H5I_type_t type, const(void)* object);
void* H5Iobject_verify (hid_t id, H5I_type_t id_type);
void* H5Iremove_verify (hid_t id, H5I_type_t id_type);
H5I_type_t H5Iget_type (hid_t id);
hid_t H5Iget_file_id (hid_t id);
ssize_t H5Iget_name (hid_t id, char* name, size_t size);
int H5Iinc_ref (hid_t id);
int H5Idec_ref (hid_t id);
int H5Iget_ref (hid_t id);
H5I_type_t H5Iregister_type (size_t hash_size, uint reserved, H5I_free_t free_func);
herr_t H5Iclear_type (H5I_type_t type, hbool_t force);
herr_t H5Idestroy_type (H5I_type_t type);
int H5Iinc_type_ref (H5I_type_t type);
int H5Idec_type_ref (H5I_type_t type);
int H5Iget_type_ref (H5I_type_t type);
void* H5Isearch (H5I_type_t type, H5I_search_func_t func, void* key);
herr_t H5Inmembers (H5I_type_t type, hsize_t* num_members);
htri_t H5Itype_exists (H5I_type_t type);
htri_t H5Iis_valid (hid_t id);