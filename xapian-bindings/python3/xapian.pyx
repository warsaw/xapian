# -*- python -*-

cimport xapianlib

from libcpp.string cimport string


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
            return <char *>self._this.get_description().c_str()

    def __str__(self):
        return self.description.decode('utf-8')


cdef class Database:
    cdef xapianlib.Database * _this

    def __cinit__(self, path=None):
        ## if path is None:
            self._this = new xapianlib.Database()
        ## else:
        ##     if isinstance(path, str):
        ##         path = path.encode('utf-8')
        ##     spath = string(<char *>path)
        ##     self._this = new xapianlib.Database(spath)

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            descr = self._this.get_description()
            return (<char *>descr.c_str()).decode('utf-8')
            #return <char *>self._this.get_description().c_str()

    def __str__(self):
        return self.description.decode('utf-8')


cdef class TermGenerator:
    cdef xapianlib.TermGenerator * _this

    def __cinit__(self):
        self._this = new xapianlib.TermGenerator()

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            # works
            descr = self._this.get_description()
            return descr.c_str()[:descr.size()].decode('utf-8')
            #return <char *>self._this.get_description().c_str()

    property destruction:
        def __get__(self):
            # broken
            as_bytes = <char *>self._this.get_description().c_str()
            return as_bytes.decode('utf-8')

    def __str__(self):
        return self.description.decode('utf-8')
