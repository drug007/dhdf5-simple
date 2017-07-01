module test2;

auto test2()
{
	import dhdf5.dataset : Dataset;

	struct Foo
	{
		uint ui;
		string s;
	}

	import std.algorithm : equal, copy;
	import dhdf5.file : H5File, H5open, H5close;
	import hdf5.hdf5 : H5S_UNLIMITED;

	H5open();
	scope(exit) H5close();

	auto file = H5File("testfile.h5", H5File.Access.Trunc);

	auto ds = Dataset!(Foo[]).create(file, "dataset");
	assert (ds.currShape == [0]);
	assert (ds.maxShape == [H5S_UNLIMITED]);

	// adding by elements
	auto foo = Foo(1, "Hello");
	ds.add(foo);
	foo = Foo(2, "World");
	ds.add(foo);
	assert (ds.currShape == [2]);
	assert (ds[].equal([Foo(1, "Hello"), Foo(2, "World")]));

	// removing the last element by index
	ds.remove(1);
	assert (ds.currShape[0] == 1);

	// setting shape
	ds.currShape = [3];
	assert (ds[].equal([Foo(1, "Hello"), Foo.init, Foo.init]));

	// access by index
	assert (ds[2] == Foo.init);
	// modifying by index
	ds[1] = Foo(4, "Welt");
	ds[2] = Foo(5, "Monde");
	assert (ds[].equal([Foo(1, "Hello"), Foo(4, "Welt"), Foo(5, "Monde")]));

	// removing the first element by index
	ds.remove(0);
	assert (ds.currShape[0] == 2);

	assert (ds[].equal([Foo(4, "Welt"), Foo(5, "Monde")]));

	ds ~= [Foo(6, "Мир"), Foo(7, "世界")];
	assert (ds.currShape[0] == 4);
	assert (ds[].equal([Foo(4, "Welt"), Foo(5, "Monde"), Foo(6, "Мир"), Foo(7, "世界")]));
}
