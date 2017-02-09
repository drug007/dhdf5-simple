module hdf5.H5Tpublic;

import core.stdc.config;

import hdf5.H5public;
import hdf5.H5Ipublic;

extern (C):

/*
 * The predefined native types. These are the types detected by H5detect and
 * they violate the naming scheme a little.  Instead of a class name,
 * precision and byte order as the last component, they have a C-like type
 * name.  If the type begins with `U' then it is the unsigned version of the
 * integer type; other integer types are signed.  The type LLONG corresponds
 * to C's `long long' and LDOUBLE is `long double' (these types might be the
 * same as `LONG' and `DOUBLE' respectively).
 */
alias H5T_NATIVE_SCHAR   = H5T_NATIVE_SCHAR_g;
alias H5T_NATIVE_UCHAR   = H5T_NATIVE_UCHAR_g;
alias H5T_NATIVE_SHORT   = H5T_NATIVE_SHORT_g;
alias H5T_NATIVE_USHORT  = H5T_NATIVE_USHORT_g;
alias H5T_NATIVE_INT     = H5T_NATIVE_INT_g;
alias H5T_NATIVE_UINT    = H5T_NATIVE_UINT_g;
alias H5T_NATIVE_LONG    = H5T_NATIVE_LONG_g;
alias H5T_NATIVE_ULONG   = H5T_NATIVE_ULONG_g;
alias H5T_NATIVE_LLONG   = H5T_NATIVE_LLONG_g;
alias H5T_NATIVE_ULLONG  = H5T_NATIVE_ULLONG_g;
alias H5T_NATIVE_FLOAT   = H5T_NATIVE_FLOAT_g;
alias H5T_NATIVE_DOUBLE  = H5T_NATIVE_DOUBLE_g;
alias H5T_NATIVE_B8      = H5T_NATIVE_B8_g;
alias H5T_NATIVE_B16     = H5T_NATIVE_B16_g;
alias H5T_NATIVE_B32     = H5T_NATIVE_B32_g;
alias H5T_NATIVE_B64     = H5T_NATIVE_B64_g;
alias H5T_NATIVE_OPAQUE  = H5T_NATIVE_OPAQUE_g;
alias H5T_NATIVE_HADDR   = H5T_NATIVE_HADDR_g;
alias H5T_NATIVE_HSIZE   = H5T_NATIVE_HSIZE_g;
alias H5T_NATIVE_HSSIZE  = H5T_NATIVE_HSSIZE_g;
alias H5T_NATIVE_HERR    = H5T_NATIVE_HERR_g;
alias H5T_NATIVE_HBOOL   = H5T_NATIVE_HBOOL_g;

//alias H5T_class_t H5T_class_t;
//alias H5T_order_t H5T_order_t;
//alias H5T_sign_t H5T_sign_t;
//alias H5T_norm_t H5T_norm_t;
//alias H5T_cset_t H5T_cset_t;
//alias H5T_str_t H5T_str_t;
//alias H5T_pad_t H5T_pad_t;
//alias H5T_cmd_t H5T_cmd_t;
//alias H5T_bkg_t H5T_bkg_t;
//alias H5T_cdata_t H5T_cdata_t;
//alias H5T_pers_t H5T_pers_t;
//alias H5T_direction_t H5T_direction_t;
//alias H5T_conv_except_t H5T_conv_except_t;
//alias H5T_conv_ret_t H5T_conv_ret_t;
alias _Anonymous_0 hvl_t;
alias int function (c_long, c_long, H5T_cdata_t*, c_ulong, c_ulong, c_ulong, void*, void*, c_long) H5T_conv_t;
alias H5T_conv_ret_t function (H5T_conv_except_t, c_long, c_long, void*, void*, void*) H5T_conv_except_func_t;

extern __gshared hid_t H5T_IEEE_F32BE_g;
extern __gshared hid_t H5T_IEEE_F32LE_g;
extern __gshared hid_t H5T_IEEE_F64BE_g;
extern __gshared hid_t H5T_IEEE_F64LE_g;
extern __gshared hid_t H5T_STD_I8BE_g;
extern __gshared hid_t H5T_STD_I8LE_g;
extern __gshared hid_t H5T_STD_I16BE_g;
extern __gshared hid_t H5T_STD_I16LE_g;
extern __gshared hid_t H5T_STD_I32BE_g;
extern __gshared hid_t H5T_STD_I32LE_g;
extern __gshared hid_t H5T_STD_I64BE_g;
extern __gshared hid_t H5T_STD_I64LE_g;
extern __gshared hid_t H5T_STD_U8BE_g;
extern __gshared hid_t H5T_STD_U8LE_g;
extern __gshared hid_t H5T_STD_U16BE_g;
extern __gshared hid_t H5T_STD_U16LE_g;
extern __gshared hid_t H5T_STD_U32BE_g;
extern __gshared hid_t H5T_STD_U32LE_g;
extern __gshared hid_t H5T_STD_U64BE_g;
extern __gshared hid_t H5T_STD_U64LE_g;
extern __gshared hid_t H5T_STD_B8BE_g;
extern __gshared hid_t H5T_STD_B8LE_g;
extern __gshared hid_t H5T_STD_B16BE_g;
extern __gshared hid_t H5T_STD_B16LE_g;
extern __gshared hid_t H5T_STD_B32BE_g;
extern __gshared hid_t H5T_STD_B32LE_g;
extern __gshared hid_t H5T_STD_B64BE_g;
extern __gshared hid_t H5T_STD_B64LE_g;
extern __gshared hid_t H5T_STD_REF_OBJ_g;
extern __gshared hid_t H5T_STD_REF_DSETREG_g;
extern __gshared hid_t H5T_UNIX_D32BE_g;
extern __gshared hid_t H5T_UNIX_D32LE_g;
extern __gshared hid_t H5T_UNIX_D64BE_g;
extern __gshared hid_t H5T_UNIX_D64LE_g;
extern __gshared hid_t H5T_C_S1_g;
extern __gshared hid_t H5T_FORTRAN_S1_g;
extern __gshared hid_t H5T_VAX_F32_g;
extern __gshared hid_t H5T_VAX_F64_g;
extern __gshared hid_t H5T_NATIVE_SCHAR_g;
extern __gshared hid_t H5T_NATIVE_UCHAR_g;
extern __gshared hid_t H5T_NATIVE_SHORT_g;
extern __gshared hid_t H5T_NATIVE_USHORT_g;
extern __gshared hid_t H5T_NATIVE_INT_g;
extern __gshared hid_t H5T_NATIVE_UINT_g;
extern __gshared hid_t H5T_NATIVE_LONG_g;
extern __gshared hid_t H5T_NATIVE_ULONG_g;
extern __gshared hid_t H5T_NATIVE_LLONG_g;
extern __gshared hid_t H5T_NATIVE_ULLONG_g;
extern __gshared hid_t H5T_NATIVE_FLOAT_g;
extern __gshared hid_t H5T_NATIVE_DOUBLE_g;
extern __gshared hid_t H5T_NATIVE_LDOUBLE_g;
extern __gshared hid_t H5T_NATIVE_B8_g;
extern __gshared hid_t H5T_NATIVE_B16_g;
extern __gshared hid_t H5T_NATIVE_B32_g;
extern __gshared hid_t H5T_NATIVE_B64_g;
extern __gshared hid_t H5T_NATIVE_OPAQUE_g;
extern __gshared hid_t H5T_NATIVE_HADDR_g;
extern __gshared hid_t H5T_NATIVE_HSIZE_g;
extern __gshared hid_t H5T_NATIVE_HSSIZE_g;
extern __gshared hid_t H5T_NATIVE_HERR_g;
extern __gshared hid_t H5T_NATIVE_HBOOL_g;
extern __gshared hid_t H5T_NATIVE_INT8_g;
extern __gshared hid_t H5T_NATIVE_UINT8_g;
extern __gshared hid_t H5T_NATIVE_INT_LEAST8_g;
extern __gshared hid_t H5T_NATIVE_UINT_LEAST8_g;
extern __gshared hid_t H5T_NATIVE_INT_FAST8_g;
extern __gshared hid_t H5T_NATIVE_UINT_FAST8_g;
extern __gshared hid_t H5T_NATIVE_INT16_g;
extern __gshared hid_t H5T_NATIVE_UINT16_g;
extern __gshared hid_t H5T_NATIVE_INT_LEAST16_g;
extern __gshared hid_t H5T_NATIVE_UINT_LEAST16_g;
extern __gshared hid_t H5T_NATIVE_INT_FAST16_g;
extern __gshared hid_t H5T_NATIVE_UINT_FAST16_g;
extern __gshared hid_t H5T_NATIVE_INT32_g;
extern __gshared hid_t H5T_NATIVE_UINT32_g;
extern __gshared hid_t H5T_NATIVE_INT_LEAST32_g;
extern __gshared hid_t H5T_NATIVE_UINT_LEAST32_g;
extern __gshared hid_t H5T_NATIVE_INT_FAST32_g;
extern __gshared hid_t H5T_NATIVE_UINT_FAST32_g;
extern __gshared hid_t H5T_NATIVE_INT64_g;
extern __gshared hid_t H5T_NATIVE_UINT64_g;
extern __gshared hid_t H5T_NATIVE_INT_LEAST64_g;
extern __gshared hid_t H5T_NATIVE_UINT_LEAST64_g;
extern __gshared hid_t H5T_NATIVE_INT_FAST64_g;
extern __gshared hid_t H5T_NATIVE_UINT_FAST64_g;

enum H5T_class_t
{
    H5T_NO_CLASS = -1,
    H5T_INTEGER = 0,
    H5T_FLOAT = 1,
    H5T_TIME = 2,
    H5T_STRING = 3,
    H5T_BITFIELD = 4,
    H5T_OPAQUE = 5,
    H5T_COMPOUND = 6,
    H5T_REFERENCE = 7,
    H5T_ENUM = 8,
    H5T_VLEN = 9,
    H5T_ARRAY = 10,
    H5T_NCLASSES = 11
}

enum H5T_order_t
{
    H5T_ORDER_ERROR = -1,
    H5T_ORDER_LE = 0,
    H5T_ORDER_BE = 1,
    H5T_ORDER_VAX = 2,
    H5T_ORDER_MIXED = 3,
    H5T_ORDER_NONE = 4
}

enum H5T_sign_t
{
    H5T_SGN_ERROR = -1,
    H5T_SGN_NONE = 0,
    H5T_SGN_2 = 1,
    H5T_NSGN = 2
}

enum H5T_norm_t
{
    H5T_NORM_ERROR = -1,
    H5T_NORM_IMPLIED = 0,
    H5T_NORM_MSBSET = 1,
    H5T_NORM_NONE = 2
}

enum H5T_cset_t
{
    H5T_CSET_ERROR = -1,
    H5T_CSET_ASCII = 0,
    H5T_CSET_UTF8 = 1,
    H5T_CSET_RESERVED_2 = 2,
    H5T_CSET_RESERVED_3 = 3,
    H5T_CSET_RESERVED_4 = 4,
    H5T_CSET_RESERVED_5 = 5,
    H5T_CSET_RESERVED_6 = 6,
    H5T_CSET_RESERVED_7 = 7,
    H5T_CSET_RESERVED_8 = 8,
    H5T_CSET_RESERVED_9 = 9,
    H5T_CSET_RESERVED_10 = 10,
    H5T_CSET_RESERVED_11 = 11,
    H5T_CSET_RESERVED_12 = 12,
    H5T_CSET_RESERVED_13 = 13,
    H5T_CSET_RESERVED_14 = 14,
    H5T_CSET_RESERVED_15 = 15
}

enum H5T_str_t
{
    H5T_STR_ERROR = -1,
    H5T_STR_NULLTERM = 0,
    H5T_STR_NULLPAD = 1,
    H5T_STR_SPACEPAD = 2,
    H5T_STR_RESERVED_3 = 3,
    H5T_STR_RESERVED_4 = 4,
    H5T_STR_RESERVED_5 = 5,
    H5T_STR_RESERVED_6 = 6,
    H5T_STR_RESERVED_7 = 7,
    H5T_STR_RESERVED_8 = 8,
    H5T_STR_RESERVED_9 = 9,
    H5T_STR_RESERVED_10 = 10,
    H5T_STR_RESERVED_11 = 11,
    H5T_STR_RESERVED_12 = 12,
    H5T_STR_RESERVED_13 = 13,
    H5T_STR_RESERVED_14 = 14,
    H5T_STR_RESERVED_15 = 15
}

enum H5T_pad_t
{
    H5T_PAD_ERROR = -1,
    H5T_PAD_ZERO = 0,
    H5T_PAD_ONE = 1,
    H5T_PAD_BACKGROUND = 2,
    H5T_NPAD = 3
}

enum H5T_cmd_t
{
    H5T_CONV_INIT = 0,
    H5T_CONV_CONV = 1,
    H5T_CONV_FREE = 2
}

enum H5T_bkg_t
{
    H5T_BKG_NO = 0,
    H5T_BKG_TEMP = 1,
    H5T_BKG_YES = 2
}

enum H5T_pers_t
{
    H5T_PERS_DONTCARE = -1,
    H5T_PERS_HARD = 0,
    H5T_PERS_SOFT = 1
}

enum H5T_direction_t
{
    H5T_DIR_DEFAULT = 0,
    H5T_DIR_ASCEND = 1,
    H5T_DIR_DESCEND = 2
}

enum H5T_conv_except_t
{
    H5T_CONV_EXCEPT_RANGE_HI = 0,
    H5T_CONV_EXCEPT_RANGE_LOW = 1,
    H5T_CONV_EXCEPT_PRECISION = 2,
    H5T_CONV_EXCEPT_TRUNCATE = 3,
    H5T_CONV_EXCEPT_PINF = 4,
    H5T_CONV_EXCEPT_NINF = 5,
    H5T_CONV_EXCEPT_NAN = 6
}

enum H5T_conv_ret_t
{
    H5T_CONV_ABORT = -1,
    H5T_CONV_UNHANDLED = 0,
    H5T_CONV_HANDLED = 1
}

struct H5T_cdata_t
{
    H5T_cmd_t command;
    H5T_bkg_t need_bkg;
    hbool_t recalc;
    void* priv;
}

struct _Anonymous_0
{
    size_t len;
    void* p;
}

hid_t H5Tcreate (H5T_class_t type, size_t size);
hid_t H5Tcopy (hid_t type_id);
herr_t H5Tclose (hid_t type_id);
htri_t H5Tequal (hid_t type1_id, hid_t type2_id);
herr_t H5Tlock (hid_t type_id);
herr_t H5Tcommit2 (hid_t loc_id, const(char)* name, hid_t type_id, hid_t lcpl_id, hid_t tcpl_id, hid_t tapl_id);
hid_t H5Topen2 (hid_t loc_id, const(char)* name, hid_t tapl_id);
herr_t H5Tcommit_anon (hid_t loc_id, hid_t type_id, hid_t tcpl_id, hid_t tapl_id);
hid_t H5Tget_create_plist (hid_t type_id);
htri_t H5Tcommitted (hid_t type_id);
herr_t H5Tencode (hid_t obj_id, void* buf, size_t* nalloc);
hid_t H5Tdecode (const(void)* buf);
herr_t H5Tflush (hid_t type_id);
herr_t H5Trefresh (hid_t type_id);
herr_t H5Tinsert (hid_t parent_id, const(char)* name, size_t offset, hid_t member_id);
herr_t H5Tpack (hid_t type_id);
hid_t H5Tenum_create (hid_t base_id);
herr_t H5Tenum_insert (hid_t type, const(char)* name, const(void)* value);
herr_t H5Tenum_nameof (hid_t type, const(void)* value, char* name, size_t size);
herr_t H5Tenum_valueof (hid_t type, const(char)* name, void* value);
hid_t H5Tvlen_create (hid_t base_id);
hid_t H5Tarray_create2 (hid_t base_id, uint ndims, const hsize_t *dim);
int H5Tget_array_ndims (hid_t type_id);
int H5Tget_array_dims2 (hid_t type_id, hsize_t *dims);
herr_t H5Tset_tag (hid_t type, const(char)* tag);
char* H5Tget_tag (hid_t type);
hid_t H5Tget_super (hid_t type);
H5T_class_t H5Tget_class (hid_t type_id);
htri_t H5Tdetect_class (hid_t type_id, H5T_class_t cls);
size_t H5Tget_size (hid_t type_id);
H5T_order_t H5Tget_order (hid_t type_id);
size_t H5Tget_precision (hid_t type_id);
int H5Tget_offset (hid_t type_id);
herr_t H5Tget_pad (hid_t type_id, H5T_pad_t* lsb, H5T_pad_t* msb);
H5T_sign_t H5Tget_sign (hid_t type_id);
herr_t H5Tget_fields (hid_t type_id, size_t* spos, size_t* epos, size_t* esize, size_t* mpos, size_t* msize);
size_t H5Tget_ebias (hid_t type_id);
H5T_norm_t H5Tget_norm (hid_t type_id);
H5T_pad_t H5Tget_inpad (hid_t type_id);
H5T_str_t H5Tget_strpad (hid_t type_id);
int H5Tget_nmembers (hid_t type_id);
char* H5Tget_member_name (hid_t type_id, uint membno);
int H5Tget_member_index (hid_t type_id, const(char)* name);
size_t H5Tget_member_offset (hid_t type_id, uint membno);
H5T_class_t H5Tget_member_class (hid_t type_id, uint membno);
hid_t H5Tget_member_type (hid_t type_id, uint membno);
herr_t H5Tget_member_value (hid_t type_id, uint membno, void* value);
H5T_cset_t H5Tget_cset (hid_t type_id);
htri_t H5Tis_variable_str (hid_t type_id);
hid_t H5Tget_native_type (hid_t type_id, H5T_direction_t direction);
herr_t H5Tset_size (hid_t type_id, size_t size);
herr_t H5Tset_order (hid_t type_id, H5T_order_t order);
herr_t H5Tset_precision (hid_t type_id, size_t prec);
herr_t H5Tset_offset (hid_t type_id, size_t offset);
herr_t H5Tset_pad (hid_t type_id, H5T_pad_t lsb, H5T_pad_t msb);
herr_t H5Tset_sign (hid_t type_id, H5T_sign_t sign);
herr_t H5Tset_fields (hid_t type_id, size_t spos, size_t epos, size_t esize, size_t mpos, size_t msize);
herr_t H5Tset_ebias (hid_t type_id, size_t ebias);
herr_t H5Tset_norm (hid_t type_id, H5T_norm_t norm);
herr_t H5Tset_inpad (hid_t type_id, H5T_pad_t pad);
herr_t H5Tset_cset (hid_t type_id, H5T_cset_t cset);
herr_t H5Tset_strpad (hid_t type_id, H5T_str_t strpad);
herr_t H5Tregister (H5T_pers_t pers, const(char)* name, hid_t src_id, hid_t dst_id, H5T_conv_t func);
herr_t H5Tunregister (H5T_pers_t pers, const(char)* name, hid_t src_id, hid_t dst_id, H5T_conv_t func);
H5T_conv_t H5Tfind (hid_t src_id, hid_t dst_id, H5T_cdata_t** pcdata);
htri_t H5Tcompiler_conv (hid_t src_id, hid_t dst_id);
herr_t H5Tconvert (hid_t src_id, hid_t dst_id, size_t nelmts, void* buf, void* background, hid_t plist_id);
herr_t H5Tcommit1 (hid_t loc_id, const(char)* name, hid_t type_id);
hid_t H5Topen1 (hid_t loc_id, const(char)* name);
hid_t H5Tarray_create1 (hid_t base_id, int ndims, const hsize_t *dim, const int perm);
int H5Tget_array_dims1 (hid_t type_id, hsize_t *dims, int perm);