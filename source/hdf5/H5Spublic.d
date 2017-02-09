module hdf5.H5Spublic;

import hdf5.H5public;
import hdf5.H5Ipublic;

extern (C):

//alias H5S_class_t H5S_class_t;
//alias H5S_seloper_t H5S_seloper_t;
alias _Anonymous_0 H5S_sel_type;

enum H5S_ALL = 0;

enum H5S_class_t
{
    H5S_NO_CLASS = -1,
    H5S_SCALAR = 0,
    H5S_SIMPLE = 1,
    H5S_NULL = 2
}

enum H5S_seloper_t
{
    H5S_SELECT_NOOP = -1,
    H5S_SELECT_SET = 0,
    H5S_SELECT_OR = 1,
    H5S_SELECT_AND = 2,
    H5S_SELECT_XOR = 3,
    H5S_SELECT_NOTB = 4,
    H5S_SELECT_NOTA = 5,
    H5S_SELECT_APPEND = 6,
    H5S_SELECT_PREPEND = 7,
    H5S_SELECT_INVALID = 8
}

enum _Anonymous_0
{
    H5S_SEL_ERROR = -1,
    H5S_SEL_NONE = 0,
    H5S_SEL_POINTS = 1,
    H5S_SEL_HYPERSLABS = 2,
    H5S_SEL_ALL = 3,
    H5S_SEL_N = 4
}

hid_t H5Screate (H5S_class_t type);
hid_t H5Screate_simple (int rank, const hsize_t *dims, const hsize_t *maxdims);
herr_t H5Sset_extent_simple (hid_t space_id, int rank, const hsize_t *dims, const hsize_t *maxdims);
hid_t H5Scopy (hid_t space_id);
herr_t H5Sclose (hid_t space_id);
herr_t H5Sencode (hid_t obj_id, void* buf, size_t* nalloc);
hid_t H5Sdecode (const(void)* buf);
hssize_t H5Sget_simple_extent_npoints (hid_t space_id);
int H5Sget_simple_extent_ndims (hid_t space_id);
int H5Sget_simple_extent_dims (hid_t space_id, const hsize_t *dims, const hsize_t *maxdims);
htri_t H5Sis_simple (hid_t space_id);
hssize_t H5Sget_select_npoints (hid_t spaceid);
herr_t H5Sselect_hyperslab (hid_t space_id, H5S_seloper_t op, const hsize_t *start, const hsize_t *_stride, const hsize_t *count, const hsize_t *_block);
herr_t H5Sselect_elements (hid_t space_id, H5S_seloper_t op, size_t num_elem, const(hsize_t)* coord);
H5S_class_t H5Sget_simple_extent_type (hid_t space_id);
herr_t H5Sset_extent_none (hid_t space_id);
herr_t H5Sextent_copy (hid_t dst_id, hid_t src_id);
htri_t H5Sextent_equal (hid_t sid1, hid_t sid2);
herr_t H5Sselect_all (hid_t spaceid);
herr_t H5Sselect_none (hid_t spaceid);
herr_t H5Soffset_simple (hid_t space_id, const(hssize_t)* offset);
htri_t H5Sselect_valid (hid_t spaceid);
htri_t H5Sis_regular_hyperslab (hid_t spaceid);
htri_t H5Sget_regular_hyperslab (hid_t spaceid, hsize_t *start, hsize_t *stride, hsize_t *count, hsize_t *block);
hssize_t H5Sget_select_hyper_nblocks (hid_t spaceid);
hssize_t H5Sget_select_elem_npoints (hid_t spaceid);
herr_t H5Sget_select_hyper_blocklist (hid_t spaceid, hsize_t startblock, hsize_t numblocks, hsize_t *buf);
herr_t H5Sget_select_elem_pointlist (hid_t spaceid, hsize_t startpoint, hsize_t numpoints, hsize_t *buf);
herr_t H5Sget_select_bounds (hid_t spaceid, hsize_t *start, hsize_t *end);
H5S_sel_type H5Sget_select_type (hid_t spaceid);