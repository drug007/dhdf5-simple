module hdf5.H5Gpublic;

import core.stdc.time;
import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5Ipublic;
import hdf5.H5Opublic;
import hdf5.H5Lpublic;
import hdf5.H5public;

extern (C):

//alias H5G_storage_type_t H5G_storage_type_t;
//alias H5G_info_t H5G_info_t;
//alias H5G_obj_t H5G_obj_t;
alias int function (c_long, const(char)*, void*) H5G_iterate_t;
//alias H5G_stat_t H5G_stat_t;

enum H5G_storage_type_t
{
    H5G_STORAGE_TYPE_UNKNOWN = -1,
    H5G_STORAGE_TYPE_SYMBOL_TABLE = 0,
    H5G_STORAGE_TYPE_COMPACT = 1,
    H5G_STORAGE_TYPE_DENSE = 2
}

enum H5G_obj_t
{
    H5G_UNKNOWN = -1,
    H5G_GROUP = 0,
    H5G_DATASET = 1,
    H5G_TYPE = 2,
    H5G_LINK = 3,
    H5G_UDLINK = 4,
    H5G_RESERVED_5 = 5,
    H5G_RESERVED_6 = 6,
    H5G_RESERVED_7 = 7
}

struct H5G_info_t
{
    H5G_storage_type_t storage_type;
    hsize_t nlinks;
    long max_corder;
    hbool_t mounted;
}

struct H5G_stat_t
{
    c_ulong[2] fileno;
    c_ulong[2] objno;
    uint nlink;
    H5G_obj_t type;
    time_t mtime;
    size_t linklen;
    H5O_stat_t ohdr;
}

hid_t H5Gcreate2 (hid_t loc_id, const(char)* name, hid_t lcpl_id, hid_t gcpl_id, hid_t gapl_id);
hid_t H5Gcreate_anon (hid_t loc_id, hid_t gcpl_id, hid_t gapl_id);
hid_t H5Gopen2 (hid_t loc_id, const(char)* name, hid_t gapl_id);
hid_t H5Gget_create_plist (hid_t group_id);
herr_t H5Gget_info (hid_t loc_id, H5G_info_t* ginfo);
herr_t H5Gget_info_by_name (hid_t loc_id, const(char)* name, H5G_info_t* ginfo, hid_t lapl_id);
herr_t H5Gget_info_by_idx (hid_t loc_id, const(char)* group_name, H5_index_t idx_type, H5_iter_order_t order, hsize_t n, H5G_info_t* ginfo, hid_t lapl_id);
herr_t H5Gclose (hid_t group_id);
herr_t H5Gflush (hid_t group_id);
herr_t H5Grefresh (hid_t group_id);
hid_t H5Gcreate1 (hid_t loc_id, const(char)* name, size_t size_hint);
hid_t H5Gopen1 (hid_t loc_id, const(char)* name);
herr_t H5Glink (hid_t cur_loc_id, H5L_type_t type, const(char)* cur_name, const(char)* new_name);
herr_t H5Glink2 (hid_t cur_loc_id, const(char)* cur_name, H5L_type_t type, hid_t new_loc_id, const(char)* new_name);
herr_t H5Gmove (hid_t src_loc_id, const(char)* src_name, const(char)* dst_name);
herr_t H5Gmove2 (hid_t src_loc_id, const(char)* src_name, hid_t dst_loc_id, const(char)* dst_name);
herr_t H5Gunlink (hid_t loc_id, const(char)* name);
herr_t H5Gget_linkval (hid_t loc_id, const(char)* name, size_t size, char* buf);
herr_t H5Gset_comment (hid_t loc_id, const(char)* name, const(char)* comment);
int H5Gget_comment (hid_t loc_id, const(char)* name, size_t bufsize, char* buf);
herr_t H5Giterate (hid_t loc_id, const(char)* name, int* idx, H5G_iterate_t op, void* op_data);
herr_t H5Gget_num_objs (hid_t loc_id, hsize_t* num_objs);
herr_t H5Gget_objinfo (hid_t loc_id, const(char)* name, hbool_t follow_link, H5G_stat_t* statbuf);
ssize_t H5Gget_objname_by_idx (hid_t loc_id, hsize_t idx, char* name, size_t size);
H5G_obj_t H5Gget_objtype_by_idx (hid_t loc_id, hsize_t idx);