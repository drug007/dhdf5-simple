#!/bin/bash

LIB="/home/drug/3rdparties/dstep/"
DSTEP="/home/drug/3rdparties/dstep/dstep"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIB

$DSTEP ./H5Apublic.h
$DSTEP ./H5Dpublic.h
$DSTEP ./H5FDmpi.h
$DSTEP ./H5FDmpio.h
$DSTEP ./H5Fpublic.h
$DSTEP ./H5Gpublic.h
$DSTEP ./H5Ipublic.h
$DSTEP ./H5Lpublic.h
#$DSTEP ./H5mpistub.h
$DSTEP ./H5Opublic.h
$DSTEP ./H5Ppublic.h
$DSTEP ./H5pubconf.h
$DSTEP ./H5public.h
$DSTEP ./H5Rpublic.h
$DSTEP ./H5Spublic.h
$DSTEP ./H5Tpublic.h
$DSTEP ./H5version.h
$DSTEP ./H5Zpublic.h
$DSTEP ./hdf5.h
$DSTEP ./H5ACpublic.h
$DSTEP ./H5Zpublic.h

