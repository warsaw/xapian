# -*- python -*-

cimport xapianlib


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


cdef class TermGenerator:
    cdef xapianlib.TermGenerator * _this

    def __cinit__(self):
        self._this = new xapianlib.TermGenerator()

    def __dealloc__(self):
        del self._this

    property description:
        def __get__(self):
            as_bytes = <char *>self._this.get_description().c_str()
            #return as_bytes
            return as_bytes.decode('utf-8')
