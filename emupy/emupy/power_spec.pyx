import numpy as np
cimport numpy as np

cdef extern void emu_tot(double *xstar, double *ystar, double* mode)
cdef extern void emu_cb(double *xstar, double *ystar, double* mode)

def init_power_spectrum_tot(cosmo, z):
    if z < 0 or z > 2.02:
        raise ValueError("z out of emulator range.")
    cosmo.check_param_range()

    cdef double xstar[9] 
    xstar[:] = [cosmo.omega_m, cosmo.omega_b, cosmo.sigma_8, cosmo.h,
                cosmo.n_s, cosmo.w_0, cosmo.w_a, cosmo.omega_nu, z]
    cdef np.ndarray[double, ndim=1, mode="c"] ystar = np.empty(351)
    cdef np.ndarray[double, ndim=1, mode="c"] mode = np.empty(351)

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
    cdef np.ndarray[double, ndim=1, mode="c"] ystar = np.empty(351)
    cdef np.ndarray[double, ndim=1, mode="c"] mode = np.empty(351)

    # fill ystar (=Pk [Mpc^3]) and mode (=k [1/Mpc])
    emu_cb(xstar, <double*> ystar.data, <double*> mode.data)

    return ystar, mode

# to get rid of ImportError: dynamic module does not define init function
if __name__ == "__main__":
    pass