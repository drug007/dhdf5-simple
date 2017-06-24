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
				Foo(33, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
				Foo(34, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
			],
			[
				Foo(47, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
				Foo(48, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
			],
			[
				Foo(57, 9., 0.197, TestEnum.d, 0.3, TestEnum.c, bar, [0.9, 0.8, 0.7], ia, chr, 71),
				Foo(62, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
				Foo(72, 5., 109.7, TestEnum.c, 3.5, TestEnum.d, bar, [1.9, 1.8, 1.7], ia, chr, 11),
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

				assert(dataset.rank   == 1); // every el instance has the only dimension
				auto curr_shape = dataset.currShape;
				assert(curr_shape.length == dataset.rank);
				assert(curr_shape[0]     == el.length); // current size is equal to el size
				auto max_shape = dataset.maxShape();
				assert(max_shape.length == dataset.rank);
				assert(max_shape[0]     == hsize_t.max); // unlimited size
			}

			// Reading from file
			{
				auto file = H5File(filename, H5File.Access.ReadOnly);
				auto dataset = Dataset!(DataType).open(file, datasetName);

				DataType foor;
				foor = dataset.read();
				assert(foor == el);

				assert(dataset.rank   == 1); // every el instance has the only dimension
				auto curr_shape = dataset.currShape; // curr_shape - current size(s), max_shape - maximum size(s)
				assert(curr_shape.length == dataset.rank);
				assert(curr_shape[0]     == el.length); // current size is equal to el size
				auto max_shape = dataset.maxShape();
				assert(max_shape.length == dataset.rank);
				assert(max_shape[0]     == hsize_t.max); // unlimited size
				// reading the first element of data - offset is 0, count is 1
				assert(dataset.read(0, 1) == [ el[0] ]);
				// reading the first two elements of data - offset is 0, count is 2
				assert(dataset.read(0, 2) == [ el[0], el[1] ]);
				// reading the second element of data - offset is 1, count is 1
				assert(dataset.read(1, 1) == [ el[1] ]);
			}
		}

		auto file  = H5File("1" ~ filename, H5File.Access.Trunc);
		auto data = foo[0][];

		auto dataset = Dataset!(typeof(data)).create(file, datasetName);

		dataset.setShape([4]);
		dataset.write(data[0..2], [0]);
		dataset.write(data[2..3], [2]);
		dataset.write(data[3..4], [3]);
		dataset.setShape([5]);
		dataset.write(data[1..2], [4]);
		dataset.setShape([6]);
		dataset.write(data[2..3], [5]);
		dataset.setShape([1]);
	}
}
