module hdf5.H5Opublic;

import core.stdc.time;
import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;

extern (C):

//alias H5O_type_t H5O_type_t;
//alias H5O_hdr_info_t H5O_hdr_info_t;
//alias H5O_info_t H5O_info_t;
alias uint H5O_msg_crt_idx_t;
alias int function (c_long, const(char)*, const(H5O_info_t)*, void*) H5O_iterate_t;
//alias H5O_mcdt_search_ret_t H5O_mcdt_search_ret_t;
alias H5O_mcdt_search_ret_t function (void*) H5O_mcdt_search_cb_t;
//alias H5O_stat_t H5O_stat_t;

enum H5O_type_t
{
    H5O_TYPE_UNKNOWN = -1,
    H5O_TYPE_GROUP = 0,
    H5O_TYPE_DATASET = 1,
    H5O_TYPE_NAMED_DATATYPE = 2,
    H5O_TYPE_NTYPES = 3
}

enum H5O_mcdt_search_ret_t
{
    H5O_MCDT_SEARCH_ERROR = -1,
    H5O_MCDT_SEARCH_CONT = 0,
    H5O_MCDT_SEARCH_STOP = 1
}

struct H5O_hdr_info_t
{
    uint version_;
    uint nmesgs;
    uint nchunks;
    uint flags;
    struct
    {
        hsize_t total;
        hsize_t meta;
        hsize_t mesg;
        hsize_t free;
    }
    struct
    {
        ulong present;
        ulong shared_;
    }
}

struct H5O_info_t
{
    c_ulong fileno;
    haddr_t addr;
    H5O_type_t type;
    uint rc;
    time_t atime;
    time_t mtime;
    time_t ctime;
    time_t btime;
    hsize_t num_attrs;
    H5O_hdr_info_t hdr;
    struct
    {
        H5_ih_info_t obj;
        H5_ih_info_t attr;
    }
}

struct H5O_stat_t
{
    hsize_t size;
    hsize_t free;
    uint nmesgs;
    uint nchunks;
}

hid_t H5Oopen (hid_t loc_id, const(char)* name, hid_t lapl_id);
hid_t H5Oopen_by_addr (hid_t loc_id, haddr_t addr);
hid_t H5Oopen_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, hid_t lapl_id);
htri_t H5Oexists_by_name (hid_t loc_id, const(char)* name, hid_t lapl_id);
herr_t H5Oget_info (hid_t loc_id, H5O_info_t* oinfo);
herr_t H5Oget_info_by_name (hid_t loc_id, const(char)* name, H5O_info_t* oinfo, hid_t lapl_id);
herr_t H5Oget_info_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, H5O_info_t* oinfo, hid_t lapl_id);
herr_t H5Olink (hid_t obj_id, hid_t new_loc_id, const(char)* new_name, hid_t lcpl_id, hid_t lapl_id);
herr_t H5Oincr_refcount (hid_t object_id);
herr_t H5Odecr_refcount (hid_t object_id);
herr_t H5Ocopy (hid_t src_loc_id, const(char)* src_name, hid_t dst_loc_id, const(char)* dst_name, hid_t ocpypl_id, hid_t lcpl_id);
herr_t H5Oset_comment (hid_t obj_id, const(char)* comment);
herr_t H5Oset_comment_by_name (hid_t loc_id, const(char)* name, const(char)* comment, hid_t lapl_id);
ssize_t H5Oget_comment (hid_t obj_id, char* comment, size_t bufsize);
ssize_t H5Oget_comment_by_name (hid_t loc_id, const(char)* name, char* comment, size_t bufsize, hid_t lapl_id);
herr_t H5Ovisit (hid_t obj_id, H5_index_t idx_type, H5_iter_order_t order, H5O_iterate_t op, void* op_data);
herr_t H5Ovisit_by_name (hid_t loc_id, const(char)* obj_name, H5_index_t idx_type, H5_iter_order_t order, H5O_iterate_t op, void* op_data, hid_t lapl_id);
herr_t H5Oclose (hid_t object_id);
herr_t H5Oflush (hid_t obj_id);
herr_t H5Orefresh (hid_t oid);
herr_t H5Odisable_mdc_flushes (hid_t object_id);
herr_t H5Oenable_mdc_flushes (hid_t object_id);
herr_t H5Oare_mdc_flushes_disabled (hid_t object_id, hbool_t* are_disabled);