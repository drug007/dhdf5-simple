import std.range;
import std.traits;

import hdf5.hdf5;

import dhdf5.dataspec;
import dhdf5.dataset;
import dhdf5.file;

struct Bar
{
    enum SOME_ENUM = 4;

    int i;
    float f;
    double d;
    char[SOME_ENUM] char_array;
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

void main()
{
    string datasetName = "dataset";

    H5open();

    // Scalar
    {
        alias DataType = int;

        DataType foo, foor;
        string filename = "autoscalar.h5";
    

        foo = 100;

        // Writing to file
        {
            auto file  = H5File(filename, H5File.Access.Trunc);
            auto dataset = Dataset!(DataType).create(file, datasetName);
            dataset.write(foo);
        }

        // Reading from file
        {
            auto file = H5File(filename, H5File.Access.ReadOnly);
            auto dataset = Dataset!(DataType).open(file, datasetName);
            
            foor = dataset.read();
            
            assert(foor == foo);
        }
    }

    // Static array of scalars
    {
        alias DataType = int[3];

        DataType foo, foor;
        string filename = "staticarrayofscalar.h5";
    

        foo = [100, 123, 200];

        // Writing to file
        {
            auto file  = H5File(filename, H5File.Access.Trunc);
            auto dataset = Dataset!(DataType).create(file, datasetName);
            dataset.write(foo);
        }

        // Reading from file
        {
            auto file = H5File(filename, H5File.Access.ReadOnly);
            auto dataset = Dataset!(DataType).open(file, datasetName);
            
            foor = dataset.read();
            
            assert(foor == foo);
        }
    }

    // Dynamic array of scalars
    {
        string filename = "dynamicarrayofscalar.h5";
    
        auto foo = [
            [100, 123, 200],
            [1, 12, 20],
            [30, 135, 72, 14, 634],
        ];

        foreach(el; foo)
        {
            alias DataType = typeof(el);

            // Writing to file
            {
                auto file  = H5File(filename, H5File.Access.Trunc);
                auto dataset = Dataset!(DataType).create(file, datasetName);
                dataset.write(el);
            }

            // Reading from file
            {
                auto file = H5File(filename, H5File.Access.ReadOnly);
                auto dataset = Dataset!(DataType).open(file, datasetName);
    
                DataType foor;            
                foor = dataset.read();
                assert(foor == el);
            }
        }
    }

    // Compound
    {
        alias DataType = Foo;
        string filename = "autocompound.h5";

        Bar bar = Bar(123, 12.3, 1.23, "fdsa");
        int[3] ia = [1, 2, 3];
        char[8] chr = "abcdefgh";
        
        DataType foo, foor;

        foo = Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71);

        // Writing to file
        {
            auto file  = H5File(filename, H5File.Access.Trunc);
            auto dataset = Dataset!(DataType).create(file, datasetName);
            dataset.write(foo);
        }

        // Reading from file
        {
            auto file = H5File(filename, H5File.Access.ReadOnly);
            auto dataset = Dataset!(DataType).open(file, datasetName);
            
            foor = dataset.read();
            
            assert(foor == foo);
        }
    }

    // Static array of compounds
    {
        alias DataType = Foo[2];
        string filename = "staticarrayofcompound.h5";

        Bar bar = Bar(123, 12.3, 1.23, "fdsa");
        int[3] ia = [1, 2, 3];
        char[8] chr = "abcdefgh";
        
        DataType foo, foor;

        foo = [
            Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
            Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
        ];

        // Writing to file
        {
            auto file  = H5File(filename, H5File.Access.Trunc);
            auto dataset = Dataset!(DataType).create(file, datasetName);
            dataset.write(foo);
        }

        // Reading from file
        {
            auto file = H5File(filename, H5File.Access.ReadOnly);
            auto dataset = Dataset!(DataType).open(file, datasetName);
            
            foor = dataset.read();
            
            assert(foor == foo);
        }
    }



    // Dynamic array of compounds
    {
        string filename = "dynamicarrayofcompound.h5";

        Bar bar = Bar(123, 12.3, 1.23, "fdsa");
        int[3] ia = [1, 2, 3];
        char[8] chr = "abcdefgh";

        auto foo = [
            [
                Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
            ],
            [
                Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
            ],
            [
                Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
                Foo(32, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
            ],
        ];

        foreach(el; foo)
        {
            alias DataType = typeof(el);

            // Writing to file
            {
                auto file  = H5File(filename, H5File.Access.Trunc);
                auto dataset = Dataset!(DataType).create(file, datasetName);
                dataset.write(el);
            }

            // Reading from file
            {
                auto file = H5File(filename, H5File.Access.ReadOnly);
                auto dataset = Dataset!(DataType).open(file, datasetName);
    
                DataType foor;            
                foor = dataset.read();
                assert(foor == el);
            }
        }
    }
}