import numpy as np
cimport numpy as np
from numpy cimport ndarray

from scipy.interpolate import PchipInterpolator
from scipy.integrate import quad

cdef extern void emu_tot(double *xstar, double *ystar, double* mode)
cdef extern void emu_cb(double *xstar, double *ystar, double* mode)

def init_power_spectrum_tot(cosmo, z):
    if z < 0 or z > 2.02:
        raise ValueError("z out of emulator range.")
    cosmo.check_param_range()

    cdef double xstar[9] 
    xstar[:] = [cosmo.omega_m, cosmo.omega_b, cosmo.sigma_8, cosmo.h,
                cosmo.n_s, cosmo.w_0, cosmo.w_a, cosmo.omega_nu, z]
    cdef ndarray[double, ndim=1, mode="c"] ystar = np.empty(351)
    cdef ndarray[double, ndim=1, mode="c"] mode = np.empty(351)

    # fill ystar (=Pk [Mpc^3]) and mode (=k [1/Mpc])
    emu_tot(xstar, <double*> ystar.data, <double*> mode.data)

    return ystar, mode

def init_power_spectrum_cb(cosmo, z):
    if z < 0 or z > 2.02:
        raise ValueError("z out of emulator range.")
    cosmo.check_param_range()

    cdef double xstar[9] 
    xstar[:] = [cosmo.omega_m, cosmo.omega_b, cosmo.sigma_8, cosmo.h,
                cosmo.n_s, cosmo.w_0, cosmo.w_a, cosmo.omega_nu, z]
    cdef ndarray[double, ndim=1, mode="c"] ystar = np.empty(351)
    cdef ndarray[double, ndim=1, mode="c"] mode = np.empty(351)

    # fill ystar (=Pk [Mpc^3]) and mode (=k [1/Mpc])
    emu_cb(xstar, <double*> ystar.data, <double*> mode.data)

    return ystar, mode

cpdef interpolate(ndarray[double, ndim=1, mode="c"] k, ndarray[double, ndim=1, mode="c"] Pk):
    return PchipInterpolator(k, Pk)

cdef inline double power_law_pk(double k, double n_s, double A) except*:
    return A*pow(k, n_s)

cpdef power_spectrum(double k, ndarray[double, ndim=1, mode="c"] par, interpolate):
    if k < par[0]:
        return power_law_pk(k, par[1], par[2])
    elif k < par[3]:
        return interpolate(k)
    else:
        return power_law_pk(k, par[4], par[5])

cdef double xi_integrand(double k, double r, ndarray[double, ndim=1, mode="c"] par, interpolate):
    return 1. / (2. * np.pi**2) * k / r * power_spectrum(k, par, interpolate)

cpdef corr_func(ndarray[double, ndim=1, mode="c"] r_vec, ndarray[double, ndim=1, mode="c"] par, interpolate):
    cdef ndarray[double, ndim=1, mode="c"] xi = np.empty(r_vec.size)
    cdef int i
    cdef double r
    for i in range(r_vec.size):
        r = r_vec[i]
        xi[i] = quad(xi_integrand, 0, np.inf, args=(r, par, interpolate), weight='sin', wvar=r)[0]
    return xi


# to get rid of ImportError: dynamic module does not define init function
if __name__ == "__main__":
    pass