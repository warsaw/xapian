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
