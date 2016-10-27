module dhdf5.dataspec;

import std.range;
import std.traits;
import std.typetuple;
import std.typecons;
import std.string: toStringz;

import hdf5.hdf5;

private
{
    alias AllowedTypes = TypeTuple!(float, int, double, char, uint, long, ulong, short);  // bool is special type and 
                                                                                          // is processed like enum 
    enum string[] VectorHdf5Types =
    [
        "H5T_NATIVE_FLOAT",
        "H5T_NATIVE_INT",
        "H5T_NATIVE_DOUBLE",
        "H5T_NATIVE_B8",
        "H5T_NATIVE_B32",
        "H5T_NATIVE_LONG",
        "H5T_NATIVE_B64",
        "H5T_NATIVE_SHORT",
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
}

auto countDimensions(T)() if(isStaticArray!T)
{
    Unqual!T t;

    size_t[] dim;

    auto countDimensionsImpl(R)()
    {
        Unqual!R r;
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

auto countDimensions(T)() if(isDynamicArray!T)
{
    size_t[] dim;

    auto countDimensionsImpl(R)()
    {
        R r;

        dim ~= H5F_UNLIMITED;
        static if(isDynamicArray!(typeof(r[0])))
        {
            return countDimensionsImpl!(typeof(r[0]))(r[0]);
        }
        else
        {
            return dim;
        }
    }

    return countDimensionsImpl!T;
}

auto countDimensions(T)(T t) if(isDynamicArray!T)
{
    size_t[] dim;

    auto countDimensionsImpl(R)(R r)
    {
        dim ~= r.length;
        static if(isDynamicArray!(typeof(r[0])))
        {
            return countDimensionsImpl!(typeof(r[0]))(r[0]);
        }
        else
        {
            return dim;
        }
    }

    return countDimensionsImpl(t);
}

/// Used as UDA to disable a field of struct of class
struct HDF5disable
{

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

    private static makeImpl(S)() if(is(S == struct))
    {
        DataAttribute[] attributes;

        template isDisabled(TP...)
        {
            auto isDisabledImpl()
            {
                bool disabled = false;
                foreach(t; TP)
                {
                    static if(t == "HDF5disabled")
                    {
                        disabled = true;
                        break;
                    }
                }

                return disabled;
            }

            enum isDisabled = isDisabledImpl();
        }

        // Создаем атрибуты
        hid_t createStruct(D)(ref DataAttribute[] attributes) if(is(D == struct))
        {
            alias TT = FieldTypeTuple!D;

            auto tid = H5Tcreate (H5T_class_t.H5T_COMPOUND, D.sizeof);

            foreach (member; FieldNameTuple!D)
            {
                enum fullName = "D." ~ member;
                enum hdf5Name = (Unqual!D).stringof ~ "." ~ member;

                mixin("alias T = typeof(" ~ fullName ~ ");");
                
                static if (staticIndexOf!(T, TT) != -1)
                {
                    mixin("alias A = " ~ fullName ~";");
                    alias TP = TypeTuple!(__traits(getAttributes, A));
                    enum disabled = isDisabled!TP; // check if field is disabled using UDA

                    static if(disabled)
                    {
                        
                    }
                    else
                    static if(is(T == bool))
                    {
                        // TODO Don't know wouldn't it be better if bool enum were created
                        // once per library in static this()?

                        // Create enum type
                        hid_t hdf5Type = H5Tenum_create (H5T_NATIVE_INT);                       
                        
                        auto val = 0;
                        auto status = H5Tenum_insert (hdf5Type, "false", &val);
                        assert(status >= 0);

                        val = 1;
                        status = H5Tenum_insert (hdf5Type, "true", &val);
                        assert(status >= 0);
                    }
                    else
                    static if(is(T == enum))
                    {
                        static assert(is(T : int), "hdf5 supports only enumeration based on integer type.");
                        // Create enum type
                        alias BaseEnumType = OriginalType!T;
                        mixin("hid_t hdf5Type = H5Tenum_create (" ~ typeToHdf5Type!BaseEnumType ~ ");");
                        
                        foreach (size_t cnt, enumMember; __traits(allMembers, T))
                        {
                            auto val = cnt;
                            auto status = H5Tenum_insert (hdf5Type, (T.stringof ~ "." ~ enumMember).toStringz, &val);
                            assert(status >= 0);
                        }
                    }
                    else static if(isStaticArray!T)
                    {
                        alias ElemType = ForeachType!T;
                        static if(is(ElemType == struct))
                        {
                            import std.conv: castFrom;

                            DataAttribute[] da;
                            auto elemType = createStruct!ElemType(da);
                            insertAttributes(elemType, da);
                            //hid_t hdf5Type = H5Tvlen_create (elemType);
                            alias dim = countDimensions!T;
                            //mixin("hid_t hdf5Type = H5Tarray_create2 (" ~ typeToHdf5Type!ElemType ~ ", " ~ dim.length.text ~ ", dim.ptr);");
                            hid_t hdf5Type = H5Tarray_create2 (elemType, castFrom!size_t.to!uint(dim.length), dim.ptr);
                        }
                        else
                        {
                            import std.conv: text;

                            alias dim = countDimensions!T;
                            mixin("hid_t hdf5Type = H5Tarray_create2 (" ~ typeToHdf5Type!ElemType ~ ", " ~ dim.length.text ~ ", dim.ptr);");
                        }
                    }
                    else static if(isDynamicArray!T)
                    {
                        alias ElemType = ElementType!T;
                        static if(is(ElemType == struct))
                        {
                            DataAttribute[] da;
                            auto elemType = createStruct!ElemType(da);
                            insertAttributes(elemType, da);
                            hid_t hdf5Type = H5Tvlen_create (elemType);
                        }
                        else
                            mixin("hid_t hdf5Type = H5Tvlen_create (" ~ typeToHdf5Type!(ForeachType!T) ~ ");");
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

                    static if(!disabled)
                    {
                        // Add the attribute
                        mixin("string varName = \"" ~ hdf5Name ~ "\";");
                        mixin("enum offset = D." ~ member ~ ".offsetof;");
                        attributes ~= DataAttribute(hdf5Type, offset, varName);
                    }
                }
            }

            return tid;
        }

        // Insert attributes of the structure into the datatype
        auto insertAttributes(hid_t hdf5Type, DataAttribute[] da)
        {
            foreach(attr; da)
            {
                auto status = H5Tinsert(hdf5Type, attr.varName.toStringz, attr.offset, attr.type);
                assert(status >= 0);
            }
        }

        auto tid = createStruct!S(attributes);

        insertAttributes(tid, attributes);

        return RefCounted!(DataSpecification!S)(tid, attributes);
    }
    
    private static makeImpl(D)() if(isScalarType!D)
    {
        mixin("hid_t tid = " ~ typeToHdf5Type!D ~ ";");

        return RefCounted!(DataSpecification!D)(tid, (DataAttribute[]).init);
    }

    private static makeImpl(D)() if(isStaticArray!D)
    {
        import std.conv: text;

        alias ElemType = ForeachType!D;

        alias dim = countDimensions!D;
        mixin("hid_t tid = H5Tarray_create2 (" ~ typeToHdf5Type!(ElemType) ~ ", " ~ dim.length.text ~ ", dim.ptr);");
        return RefCounted!(DataSpecification!D)(tid, (DataAttribute[]).init);
    }

    private static makeImpl(D)() if(isDynamicArray!D)
    {
        alias ElemType = ForeachType!D;

        mixin("hid_t tid = H5Tvlen_create (" ~ typeToHdf5Type!(ElemType) ~ ");");
        return RefCounted!(DataSpecification!D)(tid, (DataAttribute[]).init);
    }

    static make()
    {
        static if(isArray!Data) // if "outer" type of data is array it's processed on Dataset level,
                                // so skip it
        {
            return makeImpl!(ForeachType!Data);
        }
        else
        {
            return makeImpl!(Data);
        }
    }

    this(const(hid_t) tid, DataAttribute[] attributes)
    {
        _tid = tid;
        _attributes = attributes;
    }

    ~this()
    {
        static if(is(Data == struct))
        {
            H5Tclose(_tid);
        }
        else
        static if(isScalarType!Data)
        {
            // do nothing because built-in type is used(?)
        }
    }

    auto tid() const
    {
        return _tid;
    }

private:
    DataAttribute[] _attributes;
    immutable hid_t _tid = -1;
}