module hdf5.H5Ppublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5ACpublic;
import hdf5.H5Dpublic;
import hdf5.H5Ipublic;
import hdf5.H5Fpublic;
import hdf5.H5Lpublic;
import hdf5.H5Tpublic;
import hdf5.H5Zpublic;

extern (C):

/*
 * The library's property list classes
 */

alias H5P_ROOT                     = H5P_CLS_ROOT_ID_g;
alias H5P_OBJECT_CREATE            = H5P_CLS_OBJECT_CREATE_ID_g;
alias H5P_FILE_CREATE              = H5P_CLS_FILE_CREATE_ID_g;
alias H5P_FILE_ACCESS              = H5P_CLS_FILE_ACCESS_ID_g;
alias H5P_DATASET_CREATE           = H5P_CLS_DATASET_CREATE_ID_g;
alias H5P_DATASET_ACCESS           = H5P_CLS_DATASET_ACCESS_ID_g;
alias H5P_DATASET_XFER             = H5P_CLS_DATASET_XFER_ID_g;
alias H5P_FILE_MOUNT               = H5P_CLS_FILE_MOUNT_ID_g;
alias H5P_GROUP_CREATE             = H5P_CLS_GROUP_CREATE_ID_g;
alias H5P_GROUP_ACCESS             = H5P_CLS_GROUP_ACCESS_ID_g;
alias H5P_DATATYPE_CREATE          = H5P_CLS_DATATYPE_CREATE_ID_g;
alias H5P_DATATYPE_ACCESS          = H5P_CLS_DATATYPE_ACCESS_ID_g;
alias H5P_STRING_CREATE            = H5P_CLS_STRING_CREATE_ID_g;
alias H5P_ATTRIBUTE_CREATE         = H5P_CLS_ATTRIBUTE_CREATE_ID_g;
alias H5P_ATTRIBUTE_ACCESS         = H5P_CLS_ATTRIBUTE_ACCESS_ID_g;
alias H5P_OBJECT_COPY              = H5P_CLS_OBJECT_COPY_ID_g;
alias H5P_LINK_CREATE              = H5P_CLS_LINK_CREATE_ID_g;
alias H5P_LINK_ACCESS              = H5P_CLS_LINK_ACCESS_ID_g;

/*
 * The library's default property lists
 */
alias H5P_FILE_CREATE_DEFAULT      = H5P_LST_FILE_CREATE_ID_g;
alias H5P_FILE_ACCESS_DEFAULT      = H5P_LST_FILE_ACCESS_ID_g;
alias H5P_DATASET_CREATE_DEFAULT   = H5P_LST_DATASET_CREATE_ID_g;
alias H5P_DATASET_ACCESS_DEFAULT   = H5P_LST_DATASET_ACCESS_ID_g;
alias H5P_DATASET_XFER_DEFAULT     = H5P_LST_DATASET_XFER_ID_g;
alias H5P_FILE_MOUNT_DEFAULT       = H5P_LST_FILE_MOUNT_ID_g;
alias H5P_GROUP_CREATE_DEFAULT     = H5P_LST_GROUP_CREATE_ID_g;
alias H5P_GROUP_ACCESS_DEFAULT     = H5P_LST_GROUP_ACCESS_ID_g;
alias H5P_DATATYPE_CREATE_DEFAULT  = H5P_LST_DATATYPE_CREATE_ID_g;
alias H5P_DATATYPE_ACCESS_DEFAULT  = H5P_LST_DATATYPE_ACCESS_ID_g;
alias H5P_ATTRIBUTE_CREATE_DEFAULT = H5P_LST_ATTRIBUTE_CREATE_ID_g;
alias H5P_ATTRIBUTE_ACCESS_DEFAULT = H5P_LST_ATTRIBUTE_ACCESS_ID_g;
alias H5P_OBJECT_COPY_DEFAULT      = H5P_LST_OBJECT_COPY_ID_g;
alias H5P_LINK_CREATE_DEFAULT      = H5P_LST_LINK_CREATE_ID_g;
alias H5P_LINK_ACCESS_DEFAULT      = H5P_LST_LINK_ACCESS_ID_g;

alias int function (c_long, void*) H5P_cls_create_func_t;
alias int function (c_long, c_long, void*) H5P_cls_copy_func_t;
alias int function (c_long, void*) H5P_cls_close_func_t;
alias int function (const(char)*, c_ulong, void*) H5P_prp_cb1_t;
alias int function (c_long, const(char)*, c_ulong, void*) H5P_prp_cb2_t;
alias int function (const(char)*, c_ulong, void*) H5P_prp_create_func_t;
alias int function (c_long, const(char)*, c_ulong, void*) H5P_prp_set_func_t;
alias int function (c_long, const(char)*, c_ulong, void*) H5P_prp_get_func_t;
alias int function (const(void)*, void**, c_ulong*) H5P_prp_encode_func_t;
alias int function (const(void*)*, void*) H5P_prp_decode_func_t;
alias int function (c_long, const(char)*, c_ulong, void*) H5P_prp_delete_func_t;
alias int function (const(char)*, c_ulong, void*) H5P_prp_copy_func_t;
alias int function (const(void)*, const(void)*, c_ulong) H5P_prp_compare_func_t;
alias int function (const(char)*, c_ulong, void*) H5P_prp_close_func_t;
alias int function (c_long, const(char)*, void*) H5P_iterate_t;
//alias H5D_mpio_actual_chunk_opt_mode_t H5D_mpio_actual_chunk_opt_mode_t;
//alias H5D_mpio_actual_io_mode_t H5D_mpio_actual_io_mode_t;
//alias H5D_mpio_no_collective_cause_t H5D_mpio_no_collective_cause_t;

extern __gshared hid_t H5P_CLS_ROOT_ID_g;
extern __gshared hid_t H5P_CLS_OBJECT_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_FILE_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_FILE_ACCESS_ID_g;
extern __gshared hid_t H5P_CLS_DATASET_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_DATASET_ACCESS_ID_g;
extern __gshared hid_t H5P_CLS_DATASET_XFER_ID_g;
extern __gshared hid_t H5P_CLS_FILE_MOUNT_ID_g;
extern __gshared hid_t H5P_CLS_GROUP_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_GROUP_ACCESS_ID_g;
extern __gshared hid_t H5P_CLS_DATATYPE_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_DATATYPE_ACCESS_ID_g;
extern __gshared hid_t H5P_CLS_STRING_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_ATTRIBUTE_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_ATTRIBUTE_ACCESS_ID_g;
extern __gshared hid_t H5P_CLS_OBJECT_COPY_ID_g;
extern __gshared hid_t H5P_CLS_LINK_CREATE_ID_g;
extern __gshared hid_t H5P_CLS_LINK_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_FILE_CREATE_ID_g;
extern __gshared hid_t H5P_LST_FILE_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_DATASET_CREATE_ID_g;
extern __gshared hid_t H5P_LST_DATASET_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_DATASET_XFER_ID_g;
extern __gshared hid_t H5P_LST_FILE_MOUNT_ID_g;
extern __gshared hid_t H5P_LST_GROUP_CREATE_ID_g;
extern __gshared hid_t H5P_LST_GROUP_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_DATATYPE_CREATE_ID_g;
extern __gshared hid_t H5P_LST_DATATYPE_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_ATTRIBUTE_CREATE_ID_g;
extern __gshared hid_t H5P_LST_ATTRIBUTE_ACCESS_ID_g;
extern __gshared hid_t H5P_LST_OBJECT_COPY_ID_g;
extern __gshared hid_t H5P_LST_LINK_CREATE_ID_g;
extern __gshared hid_t H5P_LST_LINK_ACCESS_ID_g;

enum H5D_mpio_actual_chunk_opt_mode_t
{
    H5D_MPIO_NO_CHUNK_OPTIMIZATION = 0,
    H5D_MPIO_LINK_CHUNK = 1,
    H5D_MPIO_MULTI_CHUNK = 2
}

enum H5D_mpio_actual_io_mode_t
{
    H5D_MPIO_NO_COLLECTIVE = 0,
    H5D_MPIO_CHUNK_INDEPENDENT = 1,
    H5D_MPIO_CHUNK_COLLECTIVE = 2,
    H5D_MPIO_CHUNK_MIXED = 3,
    H5D_MPIO_CONTIGUOUS_COLLECTIVE = 4
}

enum H5D_mpio_no_collective_cause_t
{
    H5D_MPIO_COLLECTIVE = 0,
    H5D_MPIO_SET_INDEPENDENT = 1,
    H5D_MPIO_DATATYPE_CONVERSION = 2,
    H5D_MPIO_DATA_TRANSFORMS = 4,
    H5D_MPIO_MPI_OPT_TYPES_ENV_VAR_DISABLED = 8,
    H5D_MPIO_NOT_SIMPLE_OR_SCALAR_DATASPACES = 16,
    H5D_MPIO_NOT_CONTIGUOUS_OR_CHUNKED_DATASET = 32,
    H5D_MPIO_FILTERS = 64
}

/* Default value for all property list classes */
enum hid_t H5P_DEFAULT = 0;

hid_t H5Pcreate_class (hid_t parent, const(char)* name, H5P_cls_create_func_t cls_create, void* create_data, H5P_cls_copy_func_t cls_copy, void* copy_data, H5P_cls_close_func_t cls_close, void* close_data);
char* H5Pget_class_name (hid_t pclass_id);
hid_t H5Pcreate (hid_t cls_id);
herr_t H5Pregister2 (hid_t cls_id, const(char)* name, size_t size, void* def_value, H5P_prp_create_func_t prp_create, H5P_prp_set_func_t prp_set, H5P_prp_get_func_t prp_get, H5P_prp_delete_func_t prp_del, H5P_prp_copy_func_t prp_copy, H5P_prp_compare_func_t prp_cmp, H5P_prp_close_func_t prp_close);
herr_t H5Pinsert2 (hid_t plist_id, const(char)* name, size_t size, void* value, H5P_prp_set_func_t prp_set, H5P_prp_get_func_t prp_get, H5P_prp_delete_func_t prp_delete, H5P_prp_copy_func_t prp_copy, H5P_prp_compare_func_t prp_cmp, H5P_prp_close_func_t prp_close);
herr_t H5Pset (hid_t plist_id, const(char)* name, void* value);
htri_t H5Pexist (hid_t plist_id, const(char)* name);
herr_t H5Pencode (hid_t plist_id, void* buf, size_t* nalloc);
hid_t H5Pdecode (const(void)* buf);
herr_t H5Pget_size (hid_t id, const(char)* name, size_t* size);
herr_t H5Pget_nprops (hid_t id, size_t* nprops);
hid_t H5Pget_class (hid_t plist_id);
hid_t H5Pget_class_parent (hid_t pclass_id);
herr_t H5Pget (hid_t plist_id, const(char)* name, void* value);
htri_t H5Pequal (hid_t id1, hid_t id2);
htri_t H5Pisa_class (hid_t plist_id, hid_t pclass_id);
int H5Piterate (hid_t id, int* idx, H5P_iterate_t iter_func, void* iter_data);
herr_t H5Pcopy_prop (hid_t dst_id, hid_t src_id, const(char)* name);
herr_t H5Premove (hid_t plist_id, const(char)* name);
herr_t H5Punregister (hid_t pclass_id, const(char)* name);
herr_t H5Pclose_class (hid_t plist_id);
herr_t H5Pclose (hid_t plist_id);
hid_t H5Pcopy (hid_t plist_id);
herr_t H5Pset_attr_phase_change (hid_t plist_id, uint max_compact, uint min_dense);
herr_t H5Pget_attr_phase_change (hid_t plist_id, uint* max_compact, uint* min_dense);
herr_t H5Pset_attr_creation_order (hid_t plist_id, uint crt_order_flags);
herr_t H5Pget_attr_creation_order (hid_t plist_id, uint* crt_order_flags);
herr_t H5Pset_obj_track_times (hid_t plist_id, hbool_t track_times);
herr_t H5Pget_obj_track_times (hid_t plist_id, hbool_t* track_times);
//herr_t H5Pmodify_filter (hid_t plist_id, H5Z_filter_t filter, uint flags, size_t cd_nelmts, <unimplemented> cd_values);
//herr_t H5Pset_filter (hid_t plist_id, H5Z_filter_t filter, uint flags, size_t cd_nelmts, <unimplemented> c_values);
int H5Pget_nfilters (hid_t plist_id);
//H5Z_filter_t H5Pget_filter2 (hid_t plist_id, uint filter, uint* flags, size_t* cd_nelmts, <unimplemented> cd_values, size_t namelen, <unimplemented> name, uint* filter_config);
//herr_t H5Pget_filter_by_id2 (hid_t plist_id, H5Z_filter_t id, uint* flags, size_t* cd_nelmts, <unimplemented> cd_values, size_t namelen, <unimplemented> name, uint* filter_config);
htri_t H5Pall_filters_avail (hid_t plist_id);
herr_t H5Premove_filter (hid_t plist_id, H5Z_filter_t filter);
herr_t H5Pset_deflate (hid_t plist_id, uint aggression);
herr_t H5Pset_fletcher32 (hid_t plist_id);
herr_t H5Pset_userblock (hid_t plist_id, hsize_t size);
herr_t H5Pget_userblock (hid_t plist_id, hsize_t* size);
herr_t H5Pset_sizes (hid_t plist_id, size_t sizeof_addr, size_t sizeof_size);
herr_t H5Pget_sizes (hid_t plist_id, size_t* sizeof_addr, size_t* sizeof_size);
herr_t H5Pset_sym_k (hid_t plist_id, uint ik, uint lk);
herr_t H5Pget_sym_k (hid_t plist_id, uint* ik, uint* lk);
herr_t H5Pset_istore_k (hid_t plist_id, uint ik);
herr_t H5Pget_istore_k (hid_t plist_id, uint* ik);
herr_t H5Pset_shared_mesg_nindexes (hid_t plist_id, uint nindexes);
herr_t H5Pget_shared_mesg_nindexes (hid_t plist_id, uint* nindexes);
herr_t H5Pset_shared_mesg_index (hid_t plist_id, uint index_num, uint mesg_type_flags, uint min_mesg_size);
herr_t H5Pget_shared_mesg_index (hid_t plist_id, uint index_num, uint* mesg_type_flags, uint* min_mesg_size);
herr_t H5Pset_shared_mesg_phase_change (hid_t plist_id, uint max_list, uint min_btree);
herr_t H5Pget_shared_mesg_phase_change (hid_t plist_id, uint* max_list, uint* min_btree);
herr_t H5Pset_file_space (hid_t plist_id, H5F_file_space_type_t strategy, hsize_t threshold);
herr_t H5Pget_file_space (hid_t plist_id, H5F_file_space_type_t* strategy, hsize_t* threshold);
herr_t H5Pset_alignment (hid_t fapl_id, hsize_t threshold, hsize_t alignment);
herr_t H5Pget_alignment (hid_t fapl_id, hsize_t* threshold, hsize_t* alignment);
herr_t H5Pset_driver (hid_t plist_id, hid_t driver_id, const(void)* driver_info);
hid_t H5Pget_driver (hid_t plist_id);
void* H5Pget_driver_info (hid_t plist_id);
herr_t H5Pset_family_offset (hid_t fapl_id, hsize_t offset);
herr_t H5Pget_family_offset (hid_t fapl_id, hsize_t* offset);
//herr_t H5Pset_multi_type (hid_t fapl_id, H5FD_mem_t type);
//herr_t H5Pget_multi_type (hid_t fapl_id, H5FD_mem_t* type);
herr_t H5Pset_cache (hid_t plist_id, int mdc_nelmts, size_t rdcc_nslots, size_t rdcc_nbytes, double rdcc_w0);
herr_t H5Pget_cache (hid_t plist_id, int* mdc_nelmts, size_t* rdcc_nslots, size_t* rdcc_nbytes, double* rdcc_w0);
herr_t H5Pset_mdc_config (hid_t plist_id, H5AC_cache_config_t* config_ptr);
herr_t H5Pget_mdc_config (hid_t plist_id, H5AC_cache_config_t* config_ptr);
herr_t H5Pset_gc_references (hid_t fapl_id, uint gc_ref);
herr_t H5Pget_gc_references (hid_t fapl_id, uint* gc_ref);
herr_t H5Pset_fclose_degree (hid_t fapl_id, H5F_close_degree_t degree);
herr_t H5Pget_fclose_degree (hid_t fapl_id, H5F_close_degree_t* degree);
herr_t H5Pset_meta_block_size (hid_t fapl_id, hsize_t size);
herr_t H5Pget_meta_block_size (hid_t fapl_id, hsize_t* size);
herr_t H5Pset_sieve_buf_size (hid_t fapl_id, size_t size);
herr_t H5Pget_sieve_buf_size (hid_t fapl_id, size_t* size);
herr_t H5Pset_small_data_block_size (hid_t fapl_id, hsize_t size);
herr_t H5Pget_small_data_block_size (hid_t fapl_id, hsize_t* size);
herr_t H5Pset_libver_bounds (hid_t plist_id, H5F_libver_t low, H5F_libver_t high);
herr_t H5Pget_libver_bounds (hid_t plist_id, H5F_libver_t* low, H5F_libver_t* high);
herr_t H5Pset_elink_file_cache_size (hid_t plist_id, uint efc_size);
herr_t H5Pget_elink_file_cache_size (hid_t plist_id, uint* efc_size);
herr_t H5Pset_file_image (hid_t fapl_id, void* buf_ptr, size_t buf_len);
herr_t H5Pget_file_image (hid_t fapl_id, void** buf_ptr_ptr, size_t* buf_len_ptr);
//herr_t H5Pset_file_image_callbacks (hid_t fapl_id, H5FD_file_image_callbacks_t* callbacks_ptr);
//herr_t H5Pget_file_image_callbacks (hid_t fapl_id, H5FD_file_image_callbacks_t* callbacks_ptr);
herr_t H5Pset_core_write_tracking (hid_t fapl_id, hbool_t is_enabled, size_t page_size);
herr_t H5Pget_core_write_tracking (hid_t fapl_id, hbool_t* is_enabled, size_t* page_size);
herr_t H5Pset_metadata_read_attempts (hid_t plist_id, uint attempts);
herr_t H5Pget_metadata_read_attempts (hid_t plist_id, uint* attempts);
herr_t H5Pset_object_flush_cb (hid_t plist_id, H5F_flush_cb_t func, void* udata);
herr_t H5Pget_object_flush_cb (hid_t plist_id, H5F_flush_cb_t* func, void** udata);
herr_t H5Pset_mdc_log_options (hid_t plist_id, hbool_t is_enabled, const(char)* location, hbool_t start_on_access);
herr_t H5Pget_mdc_log_options (hid_t plist_id, hbool_t* is_enabled, char* location, size_t* location_size, hbool_t* start_on_access);
herr_t H5Pset_layout (hid_t plist_id, H5D_layout_t layout);
H5D_layout_t H5Pget_layout (hid_t plist_id);
herr_t H5Pset_chunk (hid_t plist_id, int ndims, const hsize_t *dim);
int H5Pget_chunk (hid_t plist_id, int max_ndims, hsize_t *dim);
herr_t H5Pset_virtual (hid_t dcpl_id, hid_t vspace_id, const(char)* src_file_name, const(char)* src_dset_name, hid_t src_space_id);
herr_t H5Pget_virtual_count (hid_t dcpl_id, size_t* count);
hid_t H5Pget_virtual_vspace (hid_t dcpl_id, size_t index);
hid_t H5Pget_virtual_srcspace (hid_t dcpl_id, size_t index);
ssize_t H5Pget_virtual_filename (hid_t dcpl_id, size_t index, char* name, size_t size);
ssize_t H5Pget_virtual_dsetname (hid_t dcpl_id, size_t index, char* name, size_t size);
herr_t H5Pset_external (hid_t plist_id, const(char)* name, off_t offset, hsize_t size);
herr_t H5Pset_chunk_opts (hid_t plist_id, uint opts);
herr_t H5Pget_chunk_opts (hid_t plist_id, uint* opts);
int H5Pget_external_count (hid_t plist_id);
herr_t H5Pget_external (hid_t plist_id, uint idx, size_t name_size, char* name, off_t* offset, hsize_t* size);
herr_t H5Pset_szip (hid_t plist_id, uint options_mask, uint pixels_per_block);
herr_t H5Pset_shuffle (hid_t plist_id);
herr_t H5Pset_nbit (hid_t plist_id);
herr_t H5Pset_scaleoffset (hid_t plist_id, H5Z_SO_scale_type_t scale_type, int scale_factor);
herr_t H5Pset_fill_value (hid_t plist_id, hid_t type_id, const(void)* value);
herr_t H5Pget_fill_value (hid_t plist_id, hid_t type_id, void* value);
herr_t H5Pfill_value_defined (hid_t plist, H5D_fill_value_t* status);
herr_t H5Pset_alloc_time (hid_t plist_id, H5D_alloc_time_t alloc_time);
herr_t H5Pget_alloc_time (hid_t plist_id, H5D_alloc_time_t* alloc_time);
herr_t H5Pset_fill_time (hid_t plist_id, H5D_fill_time_t fill_time);
herr_t H5Pget_fill_time (hid_t plist_id, H5D_fill_time_t* fill_time);
herr_t H5Pset_chunk_cache (hid_t dapl_id, size_t rdcc_nslots, size_t rdcc_nbytes, double rdcc_w0);
herr_t H5Pget_chunk_cache (hid_t dapl_id, size_t* rdcc_nslots, size_t* rdcc_nbytes, double* rdcc_w0);
herr_t H5Pset_virtual_view (hid_t plist_id, H5D_vds_view_t view);
herr_t H5Pget_virtual_view (hid_t plist_id, H5D_vds_view_t* view);
herr_t H5Pset_virtual_printf_gap (hid_t plist_id, hsize_t gap_size);
herr_t H5Pget_virtual_printf_gap (hid_t plist_id, hsize_t* gap_size);
//herr_t H5Pset_append_flush (hid_t plist_id, uint ndims, <unimplemented> boundary, H5D_append_cb_t func, void* udata);
//herr_t H5Pget_append_flush (hid_t plist_id, uint dims, <unimplemented> boundary, H5D_append_cb_t* func, void** udata);
herr_t H5Pset_efile_prefix (hid_t dapl_id, const(char)* prefix);
ssize_t H5Pget_efile_prefix (hid_t dapl_id, char* prefix, size_t size);
herr_t H5Pset_data_transform (hid_t plist_id, const(char)* expression);
ssize_t H5Pget_data_transform (hid_t plist_id, char* expression, size_t size);
herr_t H5Pset_buffer (hid_t plist_id, size_t size, void* tconv, void* bkg);
size_t H5Pget_buffer (hid_t plist_id, void** tconv, void** bkg);
herr_t H5Pset_preserve (hid_t plist_id, hbool_t status);
int H5Pget_preserve (hid_t plist_id);
herr_t H5Pset_edc_check (hid_t plist_id, H5Z_EDC_t check);
H5Z_EDC_t H5Pget_edc_check (hid_t plist_id);
herr_t H5Pset_filter_callback (hid_t plist_id, H5Z_filter_func_t func, void* op_data);
herr_t H5Pset_btree_ratios (hid_t plist_id, double left, double middle, double right);
herr_t H5Pget_btree_ratios (hid_t plist_id, double* left, double* middle, double* right);
//herr_t H5Pset_vlen_mem_manager (hid_t plist_id, H5MM_allocate_t alloc_func, void* alloc_info, H5MM_free_t free_func, void* free_info);
//herr_t H5Pget_vlen_mem_manager (hid_t plist_id, H5MM_allocate_t* alloc_func, void** alloc_info, H5MM_free_t* free_func, void** free_info);
herr_t H5Pset_hyper_vector_size (hid_t fapl_id, size_t size);
herr_t H5Pget_hyper_vector_size (hid_t fapl_id, size_t* size);
//herr_t H5Pset_type_conv_cb (hid_t dxpl_id, H5T_conv_except_func_t op, void* operate_data);
//herr_t H5Pget_type_conv_cb (hid_t dxpl_id, H5T_conv_except_func_t* op, void** operate_data);
herr_t H5Pset_create_intermediate_group (hid_t plist_id, uint crt_intmd);
herr_t H5Pget_create_intermediate_group (hid_t plist_id, uint* crt_intmd);
herr_t H5Pset_local_heap_size_hint (hid_t plist_id, size_t size_hint);
herr_t H5Pget_local_heap_size_hint (hid_t plist_id, size_t* size_hint);
herr_t H5Pset_link_phase_change (hid_t plist_id, uint max_compact, uint min_dense);
herr_t H5Pget_link_phase_change (hid_t plist_id, uint* max_compact, uint* min_dense);
herr_t H5Pset_est_link_info (hid_t plist_id, uint est_num_entries, uint est_name_len);
herr_t H5Pget_est_link_info (hid_t plist_id, uint* est_num_entries, uint* est_name_len);
herr_t H5Pset_link_creation_order (hid_t plist_id, uint crt_order_flags);
herr_t H5Pget_link_creation_order (hid_t plist_id, uint* crt_order_flags);
herr_t H5Pset_char_encoding (hid_t plist_id, H5T_cset_t encoding);
herr_t H5Pget_char_encoding (hid_t plist_id, H5T_cset_t* encoding);
herr_t H5Pset_nlinks (hid_t plist_id, size_t nlinks);
herr_t H5Pget_nlinks (hid_t plist_id, size_t* nlinks);
herr_t H5Pset_elink_prefix (hid_t plist_id, const(char)* prefix);
ssize_t H5Pget_elink_prefix (hid_t plist_id, char* prefix, size_t size);
hid_t H5Pget_elink_fapl (hid_t lapl_id);
herr_t H5Pset_elink_fapl (hid_t lapl_id, hid_t fapl_id);
herr_t H5Pset_elink_acc_flags (hid_t lapl_id, uint flags);
herr_t H5Pget_elink_acc_flags (hid_t lapl_id, uint* flags);
herr_t H5Pset_elink_cb (hid_t lapl_id, H5L_elink_traverse_t func, void* op_data);
herr_t H5Pget_elink_cb (hid_t lapl_id, H5L_elink_traverse_t* func, void** op_data);
herr_t H5Pset_copy_object (hid_t plist_id, uint crt_intmd);
herr_t H5Pget_copy_object (hid_t plist_id, uint* crt_intmd);
herr_t H5Padd_merge_committed_dtype_path (hid_t plist_id, const(char)* path);
herr_t H5Pfree_merge_committed_dtype_paths (hid_t plist_id);
//herr_t H5Pset_mcdt_search_cb (hid_t plist_id, H5O_mcdt_search_cb_t func, void* op_data);
//herr_t H5Pget_mcdt_search_cb (hid_t plist_id, H5O_mcdt_search_cb_t* func, void** op_data);
herr_t H5Pregister1 (hid_t cls_id, const(char)* name, size_t size, void* def_value, H5P_prp_create_func_t prp_create, H5P_prp_set_func_t prp_set, H5P_prp_get_func_t prp_get, H5P_prp_delete_func_t prp_del, H5P_prp_copy_func_t prp_copy, H5P_prp_close_func_t prp_close);
herr_t H5Pinsert1 (hid_t plist_id, const(char)* name, size_t size, void* value, H5P_prp_set_func_t prp_set, H5P_prp_get_func_t prp_get, H5P_prp_delete_func_t prp_delete, H5P_prp_copy_func_t prp_copy, H5P_prp_close_func_t prp_close);
//H5Z_filter_t H5Pget_filter1 (hid_t plist_id, uint filter, uint* flags, size_t* cd_nelmts, <unimplemented> cd_values, size_t namelen, <unimplemented> name);
//herr_t H5Pget_filter_by_id1 (hid_t plist_id, H5Z_filter_t id, uint* flags, size_t* cd_nelmts, <unimplemented> cd_values, size_t namelen, <unimplemented> name);
herr_t H5Pget_version (hid_t plist_id, uint* boot, uint* freelist, uint* stab, uint* shhdr);