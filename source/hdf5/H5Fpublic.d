module hdf5.H5Fpublic;

import core.sys.posix.sys.types;
import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;
import hdf5.H5ACpublic;

extern (C):

//alias H5F_scope_t H5F_scope_t;
//alias H5F_close_degree_t H5F_close_degree_t;
//alias H5F_info2_t H5F_info2_t;
//alias H5F_mem_t H5F_mem_t;
//alias H5F_sect_info_t H5F_sect_info_t;
//alias H5F_libver_t H5F_libver_t;
//alias H5F_file_space_type_t H5F_file_space_type_t;
//alias H5F_retry_info_t H5F_retry_info_t;
alias int function (c_long, void*) H5F_flush_cb_t;
//alias H5F_info1_t H5F_info1_t;

enum H5F_ACC_RDONLY     = 0x0000u;  /*absence of rdwr => rd-only */
enum H5F_ACC_RDWR       = 0x0001u;  /*open for read and write    */
enum H5F_ACC_TRUNC      = 0x0002u;  /*overwrite existing files   */
enum H5F_ACC_EXCL       = 0x0004u;  /*fail if file already exists*/
/* NOTE: 0x0008u was H5F_ACC_DEBUG, now deprecated */
enum H5F_ACC_CREAT      = 0x0010u;  /*create non-existing files  */
enum H5F_ACC_SWMR_WRITE = 0x0020u;  /*indicate that this file is
                                     * open for writing in a
                                     * single-writer/multi-reader (SWMR)
                                     * scenario.  Note that the
                                     * process(es) opening the file
                                     * for reading must open the file
                                     * with RDONLY access, and use
                                     * the special "SWMR_READ" access
                                     * flag. */
enum H5F_ACC_SWMR_READ  = 0x0040u;  /*indicate that this file is
                                     * open for reading in a
                                     * single-writer/multi-reader (SWMR)
                                     * scenario.  Note that the
                                     * process(es) opening the file
                                     * for SWMR reading must also
                                     * open the file with the RDONLY
                                     * flag.  */

/* Value passed to H5Pset_elink_acc_flags to cause flags to be taken from the
 * parent file. */
enum H5F_ACC_DEFAULT    = 0xffffu;  /*ignore setting on lapl     */

enum H5F_UNLIMITED = (cast(hsize_t)(-1L));

enum H5F_scope_t
{
    H5F_SCOPE_LOCAL = 0,
    H5F_SCOPE_GLOBAL = 1
}

enum H5F_close_degree_t
{
    H5F_CLOSE_DEFAULT = 0,
    H5F_CLOSE_WEAK = 1,
    H5F_CLOSE_SEMI = 2,
    H5F_CLOSE_STRONG = 3
}

enum H5F_mem_t
{
    H5FD_MEM_NOLIST = -1,
    H5FD_MEM_DEFAULT = 0,
    H5FD_MEM_SUPER = 1,
    H5FD_MEM_BTREE = 2,
    H5FD_MEM_DRAW = 3,
    H5FD_MEM_GHEAP = 4,
    H5FD_MEM_LHEAP = 5,
    H5FD_MEM_OHDR = 6,
    H5FD_MEM_NTYPES = 7
}

enum H5F_libver_t
{
    H5F_LIBVER_EARLIEST = 0,
    H5F_LIBVER_LATEST = 1
}

enum H5F_file_space_type_t
{
    H5F_FILE_SPACE_DEFAULT = 0,
    H5F_FILE_SPACE_ALL_PERSIST = 1,
    H5F_FILE_SPACE_ALL = 2,
    H5F_FILE_SPACE_AGGR_VFD = 3,
    H5F_FILE_SPACE_VFD = 4,
    H5F_FILE_SPACE_NTYPES = 5
}

struct H5F_info2_t
{
    static struct Super
    {
        uint version_;
        hsize_t super_size;
        hsize_t super_ext_size;
    } 

    Super super_;
    
    static struct Free
    {
        uint version_;
        hsize_t meta_size;
        hsize_t tot_space;
    }

    Free free;
    
    static struct Sohm
    {
        uint version_;
        hsize_t hdr_size;
        H5_ih_info_t msgs_info;
    }

    Sohm sohm;
}

struct H5F_sect_info_t
{
    haddr_t addr;
    hsize_t size;
}

struct H5F_retry_info_t
{
    uint nbins;
    uint*[21] retries;
}

struct H5F_info1_t
{
    hsize_t super_ext_size;
    struct
    {
        hsize_t hdr_size;
        H5_ih_info_t msgs_info;
    }
}

htri_t H5Fis_hdf5 (const(char)* filename);
hid_t H5Fcreate (const(char)* filename, uint flags, hid_t create_plist, hid_t access_plist);
hid_t H5Fopen (const(char)* filename, uint flags, hid_t access_plist);
hid_t H5Freopen (hid_t file_id);
herr_t H5Fflush (hid_t object_id, H5F_scope_t scope_);
herr_t H5Fclose (hid_t file_id);
hid_t H5Fget_create_plist (hid_t file_id);
hid_t H5Fget_access_plist (hid_t file_id);
herr_t H5Fget_intent (hid_t file_id, uint* intent);
ssize_t H5Fget_obj_count (hid_t file_id, uint types);
ssize_t H5Fget_obj_ids (hid_t file_id, uint types, size_t max_objs, hid_t* obj_id_list);
herr_t H5Fget_vfd_handle (hid_t file_id, hid_t fapl, void** file_handle);
herr_t H5Fmount (hid_t loc, const(char)* name, hid_t child, hid_t plist);
herr_t H5Funmount (hid_t loc, const(char)* name);
hssize_t H5Fget_freespace (hid_t file_id);
herr_t H5Fget_filesize (hid_t file_id, hsize_t* size);
ssize_t H5Fget_file_image (hid_t file_id, void* buf_ptr, size_t buf_len);
herr_t H5Fget_mdc_config (hid_t file_id, H5AC_cache_config_t* config_ptr);
herr_t H5Fset_mdc_config (hid_t file_id, H5AC_cache_config_t* config_ptr);
herr_t H5Fget_mdc_hit_rate (hid_t file_id, double* hit_rate_ptr);
herr_t H5Fget_mdc_size (hid_t file_id, size_t* max_size_ptr, size_t* min_clean_size_ptr, size_t* cur_size_ptr, int* cur_num_entries_ptr);
herr_t H5Freset_mdc_hit_rate_stats (hid_t file_id);
ssize_t H5Fget_name (hid_t obj_id, char* name, size_t size);
herr_t H5Fget_info2 (hid_t obj_id, H5F_info2_t* finfo);
herr_t H5Fget_metadata_read_retry_info (hid_t file_id, H5F_retry_info_t* info);
herr_t H5Fstart_swmr_write (hid_t file_id);
ssize_t H5Fget_free_sections (hid_t file_id, H5F_mem_t type, size_t nsects, H5F_sect_info_t* sect_info);
herr_t H5Fclear_elink_file_cache (hid_t file_id);
herr_t H5Fstart_mdc_logging (hid_t file_id);
herr_t H5Fstop_mdc_logging (hid_t file_id);
herr_t H5Fget_mdc_logging_status (hid_t file_id, hbool_t* is_enabled, hbool_t* is_currently_logging);
herr_t H5Fformat_convert (hid_t fid);
herr_t H5Fget_info1 (hid_t obj_id, H5F_info1_t* finfo);