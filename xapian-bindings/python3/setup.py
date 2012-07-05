from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


ext_modules = [
    Extension('xapian', ['xapian.pyx'],
              libraries=['xapian'],
              language='c++'),
    ]


setup(
    name='Xapian Python 3',
    cmdclass={'build_ext': build_ext},
    ext_modules=ext_modules,
    )
