module hdf5.H5Rpublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;
import hdf5.H5Gpublic;
import hdf5.H5Opublic;

extern (C):

alias _Anonymous_0 H5R_type_t;
alias c_ulong hobj_ref_t;
alias ubyte[12] hdset_reg_ref_t;

enum _Anonymous_0
{
    H5R_BADTYPE = -1,
    H5R_OBJECT = 0,
    H5R_DATASET_REGION = 1,
    H5R_MAXTYPE = 2
}

herr_t H5Rcreate (void* ref_, hid_t loc_id, const(char)* name, H5R_type_t ref_type, hid_t space_id);
hid_t H5Rdereference2 (hid_t obj_id, hid_t oapl_id, H5R_type_t ref_type, const(void)* ref_);
hid_t H5Rget_region (hid_t dataset, H5R_type_t ref_type, const(void)* ref_);
herr_t H5Rget_obj_type2 (hid_t id, H5R_type_t ref_type, const(void)* _ref, H5O_type_t* obj_type);
ssize_t H5Rget_name (hid_t loc_id, H5R_type_t ref_type, const(void)* ref_, char* name, size_t size);
H5G_obj_t H5Rget_obj_type1 (hid_t id, H5R_type_t ref_type, const(void)* _ref);
hid_t H5Rdereference1 (hid_t obj_id, H5R_type_t ref_type, const(void)* ref_);