module hdf5.H5Apublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Opublic : H5O_msg_crt_idx_t;
import hdf5.H5Tpublic;
import hdf5.H5Ipublic;

extern (C):

alias _Anonymous_0 H5A_info_t;
alias int function (c_long, const(char)*, const(_Anonymous_0)*, void*) H5A_operator2_t;
alias int function (c_long, const(char)*, void*) H5A_operator1_t;

struct _Anonymous_0
{
    hbool_t corder_valid;
    H5O_msg_crt_idx_t corder;
    H5T_cset_t cset;
    hsize_t data_size;
}

hid_t H5Acreate2 (hid_t loc_id, const(char)* attr_name, hid_t type_id, hid_t space_id, hid_t acpl_id, hid_t aapl_id);
hid_t H5Acreate_by_name (hid_t loc_id, const(char)* obj_name, const(char)* attr_name, hid_t type_id, hid_t space_id, hid_t acpl_id, hid_t aapl_id, hid_t lapl_id);
hid_t H5Aopen (hid_t obj_id, const(char)* attr_name, hid_t aapl_id);
hid_t H5Aopen_by_name (hid_t loc_id, const(char)* obj_name, const(char)* attr_name, hid_t aapl_id, hid_t lapl_id);
hid_t H5Aopen_by_idx (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, hid_t aapl_id, hid_t lapl_id);
herr_t H5Awrite (hid_t attr_id, hid_t type_id, const(void)* buf);
herr_t H5Aread (hid_t attr_id, hid_t type_id, void* buf);
herr_t H5Aclose (hid_t attr_id);
hid_t H5Aget_space (hid_t attr_id);
hid_t H5Aget_type (hid_t attr_id);
hid_t H5Aget_create_plist (hid_t attr_id);
ssize_t H5Aget_name (hid_t attr_id, size_t buf_size, char* buf);
ssize_t H5Aget_name_by_idx (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, char* name, size_t size, hid_t lapl_id);
hsize_t H5Aget_storage_size (hid_t attr_id);
herr_t H5Aget_info (hid_t attr_id, H5A_info_t* ainfo);
herr_t H5Aget_info_by_name (hid_t loc_id, const(char)* obj_name, const(char)* attr_name, H5A_info_t* ainfo, hid_t lapl_id);
herr_t H5Aget_info_by_idx (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, H5A_info_t* ainfo, hid_t lapl_id);
herr_t H5Arename (hid_t loc_id, const(char)* old_name, const(char)* new_name);
herr_t H5Arename_by_name (hid_t loc_id, const(char)* obj_name, const(char)* old_attr_name, const(char)* new_attr_name, hid_t lapl_id);
herr_t H5Aiterate2 (hid_t loc_id, H5_index_t idx_type, H5_iter_order_t order, hsize_t* idx, H5A_operator2_t op, void* op_data);
herr_t H5Aiterate_by_name (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t* idx, H5A_operator2_t op, void* op_data, hid_t lapd_id);
herr_t H5Adelete (hid_t loc_id, const(char)* name);
herr_t H5Adelete_by_name (hid_t loc_id, const(char)* obj_name, const(char)* attr_name, hid_t lapl_id);
herr_t H5Adelete_by_idx (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, hid_t lapl_id);
htri_t H5Aexists (hid_t obj_id, const(char)* attr_name);
htri_t H5Aexists_by_name (hid_t obj_id, const(char)* obj_name, const(char)* attr_name, hid_t lapl_id);
hid_t H5Acreate1 (hid_t loc_id, const(char)* name, hid_t type_id, hid_t space_id, hid_t acpl_id);
hid_t H5Aopen_name (hid_t loc_id, const(char)* name);
hid_t H5Aopen_idx (hid_t loc_id, uint idx);
int H5Aget_num_attrs (hid_t loc_id);
herr_t H5Aiterate1 (hid_t loc_id, uint* attr_num, H5A_operator1_t op, void* op_data);