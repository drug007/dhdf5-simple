import std.range;
import std.traits;

import hdf5.hdf5;

import dhdf5.dataspec;
import dhdf5.dataset;
import dhdf5.dataspace;
import dhdf5.file;

struct Bar
{
    int i;
    float f;
    double d;
}

enum TestEnum { a, b, c, d }

struct Foo
{
    enum SOME_ENUM = 8;

    int i;
    float f;
    double d;
    TestEnum test_enum;
    float f2;
    TestEnum test_enum2;
    Bar bar;
    float[] fa;
    int[3] ia;
    @("nonHDF5disabled")
    char[SOME_ENUM] char_array;
    union {
        int one;
        @("HDF5disabled")
        int thesame;
    }
}

enum LENGTH = 1;

void main()
{
    hsize_t[1] dim = [ LENGTH ];   /* Dataspace dimensions */

    string filename    = "autocompound.h5";
    string datasetName = "dataset";

    H5open();

    Bar bar = Bar(123, 12.3, 1.23);

    int[3] ia = [1, 2, 3];

    char[8] chr = "abcdefgh";
    Foo foo = Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71);
    Foo foor;

    // Writing to file
    {
        auto space = DataSpace!(Foo)(dim);
        auto file  = H5File(filename, H5File.Access.Trunc);

        auto dataset = Dataset!Foo(file, datasetName, space);
        dataset.write(foo);
    }

    // Reading from file
    {
        auto file = H5File(filename, H5File.Access.ReadOnly);
        auto dataset = Dataset!Foo(file, datasetName);
        
        dataset.read(foor);
        
        assert(foor == foo);
    }
}