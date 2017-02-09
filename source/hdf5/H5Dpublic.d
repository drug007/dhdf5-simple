module hdf5.H5Dpublic;

import core.stdc.config;

import hdf5.H5Ipublic;
import hdf5.H5public;

extern (C):

//alias H5D_layout_t H5D_layout_t;
//alias H5D_chunk_index_t H5D_chunk_index_t;
//alias H5D_alloc_time_t H5D_alloc_time_t;
//alias H5D_space_status_t H5D_space_status_t;
//alias H5D_fill_time_t H5D_fill_time_t;
//alias H5D_fill_value_t H5D_fill_value_t;
//alias H5D_vds_view_t H5D_vds_view_t;
alias int function (c_long, ulong*, void*) H5D_append_cb_t;
alias int function (void*, c_long, uint, const(ulong)*, void*) H5D_operator_t;
alias int function (const(void*)*, c_ulong*, void*) H5D_scatter_func_t;
alias int function (const(void)*, c_ulong, void*) H5D_gather_func_t;

enum H5D_layout_t
{
    H5D_LAYOUT_ERROR = -1,
    H5D_COMPACT = 0,
    H5D_CONTIGUOUS = 1,
    H5D_CHUNKED = 2,
    H5D_VIRTUAL = 3,
    H5D_NLAYOUTS = 4
}

enum H5D_chunk_index_t
{
    H5D_CHUNK_IDX_BTREE = 0,
    H5D_CHUNK_IDX_SINGLE = 1,
    H5D_CHUNK_IDX_NONE = 2,
    H5D_CHUNK_IDX_FARRAY = 3,
    H5D_CHUNK_IDX_EARRAY = 4,
    H5D_CHUNK_IDX_BT2 = 5,
    H5D_CHUNK_IDX_NTYPES = 6
}

enum H5D_alloc_time_t
{
    H5D_ALLOC_TIME_ERROR = -1,
    H5D_ALLOC_TIME_DEFAULT = 0,
    H5D_ALLOC_TIME_EARLY = 1,
    H5D_ALLOC_TIME_LATE = 2,
    H5D_ALLOC_TIME_INCR = 3
}

enum H5D_space_status_t
{
    H5D_SPACE_STATUS_ERROR = -1,
    H5D_SPACE_STATUS_NOT_ALLOCATED = 0,
    H5D_SPACE_STATUS_PART_ALLOCATED = 1,
    H5D_SPACE_STATUS_ALLOCATED = 2
}

enum H5D_fill_time_t
{
    H5D_FILL_TIME_ERROR = -1,
    H5D_FILL_TIME_ALLOC = 0,
    H5D_FILL_TIME_NEVER = 1,
    H5D_FILL_TIME_IFSET = 2
}

enum H5D_fill_value_t
{
    H5D_FILL_VALUE_ERROR = -1,
    H5D_FILL_VALUE_UNDEFINED = 0,
    H5D_FILL_VALUE_DEFAULT = 1,
    H5D_FILL_VALUE_USER_DEFINED = 2
}

enum H5D_vds_view_t
{
    H5D_VDS_ERROR = -1,
    H5D_VDS_FIRST_MISSING = 0,
    H5D_VDS_LAST_AVAILABLE = 1
}

hid_t H5Dcreate2 (hid_t loc_id, const(char)* name, hid_t type_id, hid_t space_id, hid_t lcpl_id, hid_t dcpl_id, hid_t dapl_id);
hid_t H5Dcreate_anon (hid_t file_id, hid_t type_id, hid_t space_id, hid_t plist_id, hid_t dapl_id);
hid_t H5Dopen2 (hid_t file_id, const(char)* name, hid_t dapl_id);
herr_t H5Dclose (hid_t dset_id);
hid_t H5Dget_space (hid_t dset_id);
herr_t H5Dget_space_status (hid_t dset_id, H5D_space_status_t* allocation);
hid_t H5Dget_type (hid_t dset_id);
hid_t H5Dget_create_plist (hid_t dset_id);
hid_t H5Dget_access_plist (hid_t dset_id);
hsize_t H5Dget_storage_size (hid_t dset_id);
haddr_t H5Dget_offset (hid_t dset_id);
herr_t H5Dread (hid_t dset_id, hid_t mem_type_id, hid_t mem_space_id, hid_t file_space_id, hid_t plist_id, void* buf);
herr_t H5Dwrite (hid_t dset_id, hid_t mem_type_id, hid_t mem_space_id, hid_t file_space_id, hid_t plist_id, const(void)* buf);
herr_t H5Diterate (void* buf, hid_t type_id, hid_t space_id, H5D_operator_t op, void* operator_data);
herr_t H5Dvlen_reclaim (hid_t type_id, hid_t space_id, hid_t plist_id, void* buf);
herr_t H5Dvlen_get_buf_size (hid_t dataset_id, hid_t type_id, hid_t space_id, hsize_t* size);
herr_t H5Dfill (const(void)* fill, hid_t fill_type, void* buf, hid_t buf_type, hid_t space);
herr_t H5Dset_extent (hid_t dset_id, const hsize_t *size);
herr_t H5Dflush (hid_t dset_id);
herr_t H5Drefresh (hid_t dset_id);
herr_t H5Dscatter (H5D_scatter_func_t op, void* op_data, hid_t type_id, hid_t dst_space_id, void* dst_buf);
herr_t H5Dgather (hid_t src_space_id, const(void)* src_buf, hid_t type_id, size_t dst_buf_size, void* dst_buf, H5D_gather_func_t op, void* op_data);
herr_t H5Ddebug (hid_t dset_id);
herr_t H5Dformat_convert (hid_t dset_id);
herr_t H5Dget_chunk_index_type (hid_t did, H5D_chunk_index_t* idx_type);
hid_t H5Dcreate1 (hid_t file_id, const(char)* name, hid_t type_id, hid_t space_id, hid_t dcpl_id);
hid_t H5Dopen1 (hid_t file_id, const(char)* name);
//herr_t H5Dextend (hid_t dset_id, <unimplemented> size);