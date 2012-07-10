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

    cdef cppclass Database:
        Database()
        Database(string path)
        string get_description()

    cdef cppclass Document:
        Document()
        string get_description()

    cdef cppclass QueryParser:
        QueryParser()
        string get_description()
        void set_database(Database& db)

    cdef cppclass Stem:
        Stem()
        Stem(string& language)
        string get_description()

    cdef cppclass TermGenerator:
        TermGenerator()
        string get_description()
        void set_stemmer(Stem& stemmer)

    cdef cppclass WritableDatabase(Database):
        WritableDatabase()
        WritableDatabase(string path, int action)
