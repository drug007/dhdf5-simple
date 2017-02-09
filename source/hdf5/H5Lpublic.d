module hdf5.H5Lpublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;
import hdf5.H5Tpublic;

extern (C):

alias _Anonymous_0 H5L_type_t;
alias _Anonymous_1 H5L_info_t;
alias int function (const(char)*, c_long, const(void)*, c_ulong, c_long) H5L_create_func_t;
alias int function (const(char)*, c_long, const(void)*, c_ulong) H5L_move_func_t;
alias int function (const(char)*, c_long, const(void)*, c_ulong) H5L_copy_func_t;
alias c_long function (const(char)*, c_long, const(void)*, c_ulong, c_long) H5L_traverse_func_t;
alias int function (const(char)*, c_long, const(void)*, c_ulong) H5L_delete_func_t;
alias c_long function (const(char)*, const(void)*, c_ulong, void*, c_ulong) H5L_query_func_t;
alias _Anonymous_2 H5L_class_t;
alias int function (c_long, const(char)*, const(_Anonymous_1)*, void*) H5L_iterate_t;
alias int function (const(char)*, const(char)*, const(char)*, const(char)*, uint*, c_long, void*) H5L_elink_traverse_t;

enum _Anonymous_0
{
    H5L_TYPE_ERROR = -1,
    H5L_TYPE_HARD = 0,
    H5L_TYPE_SOFT = 1,
    H5L_TYPE_EXTERNAL = 64,
    H5L_TYPE_MAX = 255
}

struct _Anonymous_1
{
    H5L_type_t type;
    hbool_t corder_valid;
    long corder;
    H5T_cset_t cset;
    union
    {
        haddr_t address;
        size_t val_size;
    }
}

struct _Anonymous_2
{
    int version_;
    H5L_type_t id;
    const(char)* comment;
    H5L_create_func_t create_func;
    H5L_move_func_t move_func;
    H5L_copy_func_t copy_func;
    H5L_traverse_func_t trav_func;
    H5L_delete_func_t del_func;
    H5L_query_func_t query_func;
}

herr_t H5Lmove (hid_t src_loc, const(char)* src_name, hid_t dst_loc, const(char)* dst_name, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Lcopy (hid_t src_loc, const(char)* src_name, hid_t dst_loc, const(char)* dst_name, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Lcreate_hard (hid_t cur_loc, const(char)* cur_name, hid_t dst_loc, const(char)* dst_name, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Lcreate_soft (const(char)* link_target, hid_t link_loc_id, const(char)* link_name, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Ldelete (hid_t loc_id, const(char)* name, hid_t lapl_id);
herr_t H5Ldelete_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, hid_t lapl_id);
herr_t H5Lget_val (hid_t loc_id, const(char)* name, void* buf, size_t size, hid_t lapl_id);
herr_t H5Lget_val_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, void* buf, size_t size, hid_t lapl_id);
htri_t H5Lexists (hid_t loc_id, const(char)* name, hid_t lapl_id);
herr_t H5Lget_info (hid_t loc_id, const(char)* name, H5L_info_t* linfo, hid_t lapl_id);
herr_t H5Lget_info_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, H5L_info_t* linfo, hid_t lapl_id);
ssize_t H5Lget_name_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, char* name, size_t size, hid_t lapl_id);
herr_t H5Literate (hid_t grp_id, H5_index_t idx_type, H5_iter_order_t order, hsize_t* idx, H5L_iterate_t op, void* op_data);
herr_t H5Literate_by_name (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t* idx, H5L_iterate_t op, void* op_data, hid_t lapl_id);
herr_t H5Lvisit (hid_t grp_id, H5_index_t idx_type, H5_iter_order_t order, H5L_iterate_t op, void* op_data);
herr_t H5Lvisit_by_name (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, H5L_iterate_t op, void* op_data, hid_t lapl_id);
herr_t H5Lcreate_ud (hid_t link_loc_id, const(char)* link_name, H5L_type_t link_type, const(void)* udata, size_t udata_size, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Lregister (const(H5L_class_t)* cls);
herr_t H5Lunregister (H5L_type_t id);
htri_t H5Lis_registered (H5L_type_t id);
herr_t H5Lunpack_elink_val (const(void)* ext_linkval, size_t link_size, uint* flags, const(char*)* filename, const(char*)* obj_path);
herr_t H5Lcreate_external (const(char)* file_name, const(char)* obj_name, hid_t link_loc_id, const(char)* link_name, hid_t lcpl_id, hid_t lapl_id);