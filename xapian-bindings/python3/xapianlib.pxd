# -*- python -*-

from libcpp.string cimport string

cdef extern from "xapian.h" namespace "Xapian":
    int major_version()
    int minor_version()
    int revision()
    char * version_string()

    cdef cppclass Document:
        # Make a new empty Document
        Document()
        string get_description()

    cdef cppclass Database:
        Database()
        Database(string path)
        string get_description()

    cdef cppclass TermGenerator:
        # Default constructor.
        TermGenerator()
        string get_description()
