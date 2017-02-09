module hdf5.H5public;

import core.stdc.config;

extern (C):

alias int herr_t;
alias bool hbool_t;
alias int htri_t;
alias ulong hsize_t;
alias long hssize_t;
alias c_ulong haddr_t;
alias _Anonymous_0 H5_iter_order_t;
//alias H5_index_t H5_index_t;
//alias H5_ih_info_t H5_ih_info_t;

enum _Anonymous_0
{
    H5_ITER_UNKNOWN = -1,
    H5_ITER_INC = 0,
    H5_ITER_DEC = 1,
    H5_ITER_NATIVE = 2,
    H5_ITER_N = 3
}

enum H5_index_t
{
    H5_INDEX_UNKNOWN = -1,
    H5_INDEX_NAME = 0,
    H5_INDEX_CRT_ORDER = 1,
    H5_INDEX_N = 2
}

struct H5_ih_info_t
{
    hsize_t index_size;
    hsize_t heap_size;
}

herr_t H5open ();
herr_t H5close ();
herr_t H5dont_atexit ();
herr_t H5garbage_collect ();
herr_t H5set_free_list_limits (int reg_global_lim, int reg_list_lim, int arr_global_lim, int arr_list_lim, int blk_global_lim, int blk_list_lim);
herr_t H5get_libversion (uint* majnum, uint* minnum, uint* relnum);
herr_t H5check_version (uint majnum, uint minnum, uint relnum);
herr_t H5is_library_threadsafe (hbool_t* is_ts);
herr_t H5free_memory (void* mem);
void* H5allocate_memory (size_t size, hbool_t clear);
void* H5resize_memory (void* mem, size_t size);