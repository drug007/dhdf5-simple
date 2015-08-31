module dataspec;

import std.range;
import std.traits;
import std.typetuple;

import hdf5.hdf5;

private
{
    alias AllowedTypes = TypeTuple!(float, int, double);
    enum string[] VectorHdf5Types =
    [
        "H5T_NATIVE_FLOAT",
        "H5T_NATIVE_INT",
        "H5T_NATIVE_DOUBLE",
    ];

    template typeToHdf5Type(T)
    {
        alias U = Unqual!T;
        enum index = staticIndexOf!(U, AllowedTypes);
        static if (index == -1)
        {
            static assert(false, "Could not use " ~ T.stringof ~ ", there is no corresponding hdf5 data type");
        }
        else
        {
            enum typeToHdf5Type = VectorHdf5Types[index];
        }
    }

    auto countDimensions(T)() if(isStaticArray!T)
    {
        T t;

        size_t[] dim;

        auto countDimensionsImpl(R)()
        {
            R r;
            dim ~= R.length;
            static if(isStaticArray!(typeof(r[0])))
            {
                return countDimensionsImpl!(typeof(r[0]));
            }
            else
            {
                return dim;
            }
        }

        return countDimensionsImpl!T;
    }
}

struct DataAttribute
{
    hid_t type;
    size_t offset;
    string varName;
}

struct DataSpecification(Data)
{    
    alias DataType = Data;

    @disable this();

    static make()
    {
        alias TT = FieldTypeTuple!Data;

        DataAttribute[] attributes;

        // Создаем атрибуты
        hid_t createStruct(D)(ref DataAttribute[] attributes) if(is(Data == struct))
        {
            auto tid = H5Tcreate (H5T_class_t.H5T_COMPOUND, D.sizeof);

            foreach (member; __traits(allMembers, D))
            {
                enum fullName = "D." ~ member;
                enum hdf5Name = fullyQualifiedName!D ~ "." ~ member;

                mixin("alias T = typeof(" ~ fullName ~ ");");
                
                static if (staticIndexOf!(T, TT) != -1)
                {
                    static if(is(T == enum))
                    {
                        static assert(is(T : int), "hdf5 supports only enumeration based on integer type.");
                        // Create enum type
                        alias BaseEnumType = OriginalType!T;
                        mixin("hid_t hdf5Type = H5Tenum_create (" ~ typeToHdf5Type!BaseEnumType ~ ");");
                        
                        
                        foreach (enumMember; EnumMembers!T)
                        {
                            auto val = enumMember;
                            auto status = H5Tenum_insert (hdf5Type, enumMember.stringof.ptr, &val);
                            assert(status >= 0);
                        }
                    }
                    else static if(isStaticArray!T)
                    {
                        import std.conv: text;
                        alias dim = countDimensions!T;
                        mixin("hid_t hdf5Type = H5Tarray_create2 (" ~ typeToHdf5Type!(ElementType!T) ~ ", " ~ dim.length.text ~ ", dim.ptr);");
                    }
                    else static if(isInputRange!T)
                    {
                        mixin("hid_t hdf5Type = H5Tvlen_create (" ~ typeToHdf5Type!(ElementType!T) ~ ");");
                    }
                    else static if(is(T == struct))
                    {
                        DataAttribute[] da;
                        auto hdf5Type = createStruct!T(da);

                        insertAttributes(hdf5Type, da);
                    }
                    else
                    {
                        mixin("hid_t hdf5Type = " ~ typeToHdf5Type!T ~ ";");
                    }

                    // Add the attribute
                    mixin("string varName = \"" ~ hdf5Name ~ "\";");
                    mixin("enum offset = D." ~ member ~ ".offsetof;");
                    attributes ~= DataAttribute(hdf5Type, offset, varName);
                }
            }

            return tid;
        }

        // Insert attributes of the structure into the datatype
        auto insertAttributes(hid_t hdf5Type, DataAttribute[] da)
        {
            foreach(attr; da)
            {
                auto status = H5Tinsert(hdf5Type, attr.varName.ptr, attr.offset, attr.type);
                assert(status >= 0);
            }
        }

        auto tid = createStruct!Data(attributes);

        insertAttributes(tid, attributes);

        return DataSpecification!Data(tid, attributes);
    }

    this(const(hid_t) tid, DataAttribute[] attributes)
    {
        _tid = tid;
        _attributes = attributes;
    }

    ~this()
    {
        H5Tclose(_tid);
    }

    auto tid() const
    {
        return _tid;
    }

private:
    DataAttribute[] _attributes;
    immutable hid_t _tid;
    const(Data*) _data_ptr;
}