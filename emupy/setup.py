#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import numpy

setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("power_spec",
                             sources=["emupy/power_spec.pyx", "../P_tot/emu.c", "../P_cb/emu.c"],
                             include_dirs=[numpy.get_include()],
                             libraries=["m", "gsl", "gslcblas"]
                             )],
)