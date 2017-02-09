module hdf5.H5ACpublic;

import core.stdc.config;

import hdf5.H5public;

extern (C):

//alias H5AC_cache_config_t H5AC_cache_config_t;

struct H5AC_cache_config_t
{
    int version_;
    hbool_t rpt_fcn_enabled;
    hbool_t open_trace_file;
    hbool_t close_trace_file;
    char[1025] trace_file_name;
    hbool_t evictions_enabled;
    hbool_t set_initial_size;
    size_t initial_size;
    double min_clean_fraction;
    size_t max_size;
    size_t min_size;
    c_long epoch_length;
    enum H5C_cache_incr_mode
    {
        H5C_incr__off = 0,
        H5C_incr__threshold = 1
    }
    H5C_cache_incr_mode incr_mode;
    double lower_hr_threshold;
    double increment;
    hbool_t apply_max_increment;
    size_t max_increment;
    enum H5C_cache_flash_incr_mode
    {
        H5C_flash_incr__off = 0,
        H5C_flash_incr__add_space = 1
    }
    H5C_cache_flash_incr_mode flash_incr_mode;
    double flash_multiple;
    double flash_threshold;
    enum H5C_cache_decr_mode
    {
        H5C_decr__off = 0,
        H5C_decr__threshold = 1,
        H5C_decr__age_out = 2,
        H5C_decr__age_out_with_threshold = 3
    }
    H5C_cache_decr_mode decr_mode;
    double upper_hr_threshold;
    double decrement;
    hbool_t apply_max_decrement;
    size_t max_decrement;
    int epochs_before_eviction;
    hbool_t apply_empty_reserve;
    double empty_reserve;
    size_t dirty_bytes_threshold;
    int metadata_write_strategy;
}