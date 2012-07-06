# -*- python -*-

cimport xapianlib

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


cdef class Document:
    cdef xapianlib.Document * _this

    def __cinit__(self):
        self._this = new xapianlib.Document()

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            # XXX Use this instead of the obvious alternative one-liner
            # because of a strange bug in Cython.  If you let Cython calculate
            # the size of the .c_str() it will use strlen() and this causes
            # the resulting unicode to be filled with nonsense.
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')

    def __str__(self):
        return self.description


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


cdef class WritableDatabase:
    cdef xapianlib.WritableDatabase * _this

    def __cinit__(self):
        self._this = NULL

    def __dealloc__(self):
        if self._this != NULL:
            del self._this

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
