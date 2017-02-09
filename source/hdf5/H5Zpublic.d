module hdf5.H5Zpublic;

import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;
import hdf5.H5Tpublic;

extern (C):

alias int H5Z_filter_t;
//alias H5Z_SO_scale_type_t H5Z_SO_scale_type_t;
//alias H5Z_EDC_t H5Z_EDC_t;
//alias H5Z_cb_return_t H5Z_cb_return_t;
alias H5Z_cb_return_t function (int, void*, c_ulong, void*) H5Z_filter_func_t;
//alias H5Z_cb_t H5Z_cb_t;
alias int function (c_long, c_long, c_long) H5Z_can_apply_func_t;
alias int function (c_long, c_long, c_long) H5Z_set_local_func_t;
alias c_ulong function (uint, c_ulong, const(uint)*, c_ulong, c_ulong*, void**) H5Z_func_t;
//alias H5Z_class2_t H5Z_class2_t;
//alias H5Z_class1_t H5Z_class1_t;

enum H5Z_SO_scale_type_t
{
    H5Z_SO_FLOAT_DSCALE = 0,
    H5Z_SO_FLOAT_ESCALE = 1,
    H5Z_SO_INT = 2
}

enum H5Z_EDC_t
{
    H5Z_ERROR_EDC = -1,
    H5Z_DISABLE_EDC = 0,
    H5Z_ENABLE_EDC = 1,
    H5Z_NO_EDC = 2
}

enum H5Z_cb_return_t
{
    H5Z_CB_ERROR = -1,
    H5Z_CB_FAIL = 0,
    H5Z_CB_CONT = 1,
    H5Z_CB_NO = 2
}

struct H5Z_cb_t
{
    H5Z_filter_func_t func;
    void* op_data;
}

struct H5Z_class2_t
{
    int version_;
    H5Z_filter_t id;
    uint encoder_present;
    uint decoder_present;
    const(char)* name;
    H5Z_can_apply_func_t can_apply;
    H5Z_set_local_func_t set_local;
    H5Z_func_t filter;
}

struct H5Z_class1_t
{
    H5Z_filter_t id;
    const(char)* name;
    H5Z_can_apply_func_t can_apply;
    H5Z_set_local_func_t set_local;
    H5Z_func_t filter;
}

herr_t H5Zregister (const(void)* cls);
herr_t H5Zunregister (H5Z_filter_t id);
htri_t H5Zfilter_avail (H5Z_filter_t id);
herr_t H5Zget_filter_info (H5Z_filter_t filter, uint* filter_config_flags);