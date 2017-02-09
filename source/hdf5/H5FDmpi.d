module hdf5.H5FDmpi;

extern (C):

//alias H5FD_mpio_xfer_t H5FD_mpio_xfer_t;
//alias H5FD_mpio_chunk_opt_t H5FD_mpio_chunk_opt_t;
//alias H5FD_mpio_collective_opt_t H5FD_mpio_collective_opt_t;

enum H5FD_mpio_xfer_t
{
    H5FD_MPIO_INDEPENDENT = 0,
    H5FD_MPIO_COLLECTIVE = 1
}

enum H5FD_mpio_chunk_opt_t
{
    H5FD_MPIO_CHUNK_DEFAULT = 0,
    H5FD_MPIO_CHUNK_ONE_IO = 1,
    H5FD_MPIO_CHUNK_MULTI_IO = 2
}

enum H5FD_mpio_collective_opt_t
{
    H5FD_MPIO_COLLECTIVE_IO = 0,
    H5FD_MPIO_INDIVIDUAL_IO = 1
}