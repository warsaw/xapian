# -*- python -*-

from libcpp.string cimport string

ctypedef unsigned docid
ctypedef unsigned termcount

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
        Document(Document& document)
        string get_description()
        docid get_docid()
        string serialise()
        string get_data()
        void set_data(string& data)
        termcount termlist_count()
        void add_term(string& tname, termcount wdfinc)

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
        void set_document(Document& document)
        Document& get_document()
        termcount get_termpos()
        void set_termpos(termcount termpos)
        void increase_termpos(termcount delta)
        void index_text(string& text, termcount wdf_inc, string& prefix)

    cdef cppclass WritableDatabase(Database):
        WritableDatabase()
        WritableDatabase(string path, int action)
