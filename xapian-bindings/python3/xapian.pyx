# -*- python -*-

cimport xapianlib

from cython.operator import dereference as deref
from libcpp.string cimport string


class XapianError(BaseException):
    """An error occurred in Xapian."""


cdef class _Xapian:
    property major_version:
        def __get__(self):
            return xapianlib.major_version()

    property minor_version:
        def __get__(self):
            return xapianlib.minor_version()

    property revision:
        def __get__(self):
            return xapianlib.revision()

    property version_string:
        def __get__(self):
            return (<char*>xapianlib.version_string()).decode('utf-8')


Xapian = _Xapian()


class DatabaseOpenError(XapianError):
    """An exception occurred while opening the database.

    I wish I could give you more information about the problem. :(
    """


cdef void raise_dbopenerror() except *:
    raise DatabaseOpenError()


cdef class Database:
    cdef xapianlib.Database * _this

    def __cinit__(self):
        self._this = NULL

    def __dealloc__(self):
        if self._this != NULL:
            del self._this

    cdef _open(self, path) except +raise_dbopenerror:
        if isinstance(path, str):
            path = path.encode('utf-8')
        self._this = new xapianlib.Database(<string>(<char*>path))

    def __init__(self, path=None):
        if path is None:
            self._this = new xapianlib.Database()
        else:
            self._open(path)

    property description:
        def __get__(self):
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    def __str__(self):
        return self.description


cdef class Document:
    cdef xapianlib.Document * _this

    def __cinit__(self):
        self._this = new xapianlib.Document()

    cdef _pivot(self, xapianlib.Document * document):
        del self._this
        self._this = document

    def __dealloc__(self):
        del self._this

    def __richcmp__(self, other, op):
        cdef my_docid = self.docid
        cdef your_docid = other.docid
        # Do ordered comparisons by docid make sense?
        if op == 0:
            return my_docid < your_docid
        elif op == 1:
            return my_docid <= your_docid
        elif op == 2:
            return my_docid == your_docid
        elif op == 3:
            return my_docid != your_docid
        elif op == 4:
            return my_docid > your_docid
        elif op == 5:
            return my_docid >= your_docid
        else:
            raise RuntimeError('unexpected comparison operator: {}'.format(op))

    def __str__(self):
        return self.description

    property description:
        def __get__(self):
            # XXX Use this instead of the obvious alternative one-liner
            # because of a strange bug in Cython.  If you let Cython calculate
            # the size of the .c_str() it will use strlen() and this causes
            # the resulting unicode to be filled with nonsense.
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    property docid:
        def __get__(self):
            return self._this.get_docid()


cdef class QueryParser:
    cdef xapianlib.QueryParser * _this

    def __cinit__(self):
        self._this = new xapianlib.QueryParser()

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    def __str__(self):
        return self.description

    def set_database(self, Database db):
        cdef xapianlib.Database * xdb = <xapianlib.Database *>(db._this)
        # Cython for .set_database(*xdb)
        self._this.set_database(xdb[0])


cdef class Stem:
    cdef xapianlib.Stem * _this

    def __cinit__(self, language=None):
        if language is None:
            self._this = new xapianlib.Stem()
        else:
            if isinstance(language, str):
                language = language.encode('utf-8')
            self._this = new xapianlib.Stem(<string>(<char*>language))

    property description:
        def __get__(self):
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    def __str__(self):
        return self.description


cdef class TermGenerator:
    cdef xapianlib.TermGenerator * _this

    def __cinit__(self):
        self._this = new xapianlib.TermGenerator()

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    def __str__(self):
        return self.description

    def set_stemmer(self, Stem stemmer):
        cdef xapianlib.Stem * xstem = <xapianlib.Stem *>(stemmer._this)
        self._this.set_stemmer(xstem[0])

    property document:
        def __get__(self):
            ## cdef xapianlib.TermGenerator * tg = <xapianlib.TermGenerator *>(
            ##     self._this)
            ## document = Document()
            ## cdef xapianlib.Document& xdoc = tg.get_document()
            ## document._this = &xdoc
            ## return document
            document = Document()
            document._pivot(new xapianlib.Document(self._this.get_document()))
            return document

        def __set__(self, Document document):
            cdef xapianlib.Document * xdoc = <xapianlib.Document *>(
                document._this)
            self._this.set_document(xdoc[0])


cdef class WritableDatabase(Database):
    cdef _open(self, path,
               action=xapianlib.DB_CREATE_OR_OPEN) except +raise_dbopenerror:
        if isinstance(path, str):
            path = path.encode('utf-8')
        self._this = new xapianlib.WritableDatabase(
            <string>(<char*>path), action)

    def __init__(self, path=None):
        if path is None:
            self._this = new xapianlib.WritableDatabase()
        else:
            self._open(path)
