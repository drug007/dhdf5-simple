dhdf5-simple
========

D wrapper for the [HDF5 library](http://www.hdfgroup.org/HDF5/) using [hdf5-d](https://github.com/SFrijters/hdf5-d) bindings.

## License

These bindings are made available under the [Boost Software License 1.0](http://www.boost.org/LICENSE_1_0.txt).
HDF5 is subject to [its own license](COPYING).

## Features

The first purpose is automatic conversion D types to HDF5 types.

## Running

D wrapper is a source library, but it have test in `test` directory that can be used as an example and can be run using
`dub --config=test`.

For example we have datastructure like:
```
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
```
You don't need to define corresponding HDF5 type. All what you need is
define the variable and initialize it:
```
Foo foo = Foo(17, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71);
```
then create a dataset:
```
auto dataset = Dataset!Foo(file, datasetName, space);
```
and finally write data:
```
dataset.write(foo);
```
Now you can use `h5dump` to check `autocompound.h5`. Command `h5dump autocompound.h5` should show you the following
```
HDF5 "autocompound.h5" {
GROUP "/" {
   DATASET "dataset" {
      DATATYPE  H5T_COMPOUND {
         H5T_STD_I32LE "test.Foo.i";
         H5T_IEEE_F32LE "test.Foo.f";
         H5T_IEEE_F64LE "test.Foo.d";
         H5T_ENUM {
            H5T_STD_I32LE;
            "cast(TestEnum)0"  0;
            "cast(TestEnum)1"  1;
            "cast(TestEnum)2"  2;
            "cast(TestEnum)3"  3;
         } "test.Foo.test_enum";
         H5T_IEEE_F32LE "test.Foo.f2";
         H5T_ENUM {
            H5T_STD_I32LE;
            "cast(TestEnum)0"  0;
            "cast(TestEnum)1"  1;
            "cast(TestEnum)2"  2;
            "cast(TestEnum)3"  3;
         } "test.Foo.test_enum2";
         H5T_COMPOUND {
            H5T_STD_I32LE "test.Bar.i";
            H5T_IEEE_F32LE "test.Bar.f";
            H5T_IEEE_F64LE "test.Bar.d";
            H5T_ARRAY { [4] H5T_STD_B8LE } "test.Bar.char_array";
         } "test.Foo.bar";
         H5T_VLEN { H5T_IEEE_F32LE} "test.Foo.fa";
         H5T_ARRAY { [3] H5T_STD_I32LE } "test.Foo.ia";
         H5T_ARRAY { [8] H5T_STD_B8LE } "test.Foo.char_array";
         H5T_STD_I32LE "test.Foo.one";
      }
      DATASPACE  SIMPLE { ( 1 ) / ( 1 ) }
      DATA {
      (0): {
            17,
            9,
            0.197,
            cast(TestEnum)3,
            0.3,
            cast(TestEnum)2,
            {
               123,
               12.3,
               1.23,
               [ 0x66, 0x64, 0x73, 0x61 ]
            },
            (0.9, 0.8, 0.7),
            [ 1, 2, 3 ],
            [ 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68 ],
            71
         }
      }
   }
}
}
```
You don't need define types. You don't even need to imagine name of these types. Just do what YOU need, not hdf5 library. :)
Test shows that you can define some type and dhdf5-simple automatically convert it to HDF5 format. You don't need to create boiler plate.

## Limitations/Known issues

- dhdf5-simple supports only structures, arrays (dynamic and static) and unions and some builtin data types. Adding another D types isn't complex but there is lack of time.

- This is a work in progress tested only in the context of its use in private project.

- Pull requests to improve this wrapper are welcomed!

