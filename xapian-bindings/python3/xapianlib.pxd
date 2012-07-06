# -*- python -*-

from libcpp.string cimport string

cdef int raise_py_error()

cdef extern from "xapian.h" namespace "Xapian":
    int major_version()
    int minor_version()
    int revision()
    char * version_string()

    enum: DB_CREATE_OR_OPEN
    enum: DB_CREATE
    enum: DB_CREATE_OR_OVERWRITE
    enum: DB_OPEN

    cdef cppclass Document:
        # Make a new empty Document
        Document()
        string get_description()

    cdef cppclass Database:
        Database()
        Database(string path)
        string get_description()

    cdef cppclass WritableDatabase:
        WritableDatabase()
        WritableDatabase(string path, int action)
        string get_description()

    cdef cppclass TermGenerator:
        # Default constructor.
        TermGenerator()
        string get_description()
