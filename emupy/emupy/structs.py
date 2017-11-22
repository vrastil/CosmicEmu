
class CosmoParam(object):
    def __init__(self, Omega_m=0.3075, Omega_b=0.0486, sigma_8=0.8159, h=0.67, n_s=0.9667, w_0=-1, w_a=0., Omega_nu=0.):
        self.Omega_m = Omega_m
        self.Omega_b = Omega_b
        self.sigma_8 = sigma_8
        self.h = h
        self.n_s = n_s
        self.w_0 = w_0
        self.w_a = w_a
        self.Omega_nu = Omega_nu

        self.set_omega_m()
        self.set_omega_b()
        self.set_omega_nu()
        self.set_H0()

        self.check_param_range()
    
    def set_omega_m(self):
        self.omega_m = self.Omega_m*self.h**2

    def set_omega_b(self):
        self.omega_b = self.Omega_b*self.h**2

    def set_omega_nu(self):
        self.omega_nu = self.Omega_nu*self.h**2

    def set_H0(self):
        self.H0 = 100*self.h

    def check_param_range(self):
        if self.omega_m < 0.12 or self.omega_m > 0.155:
            raise ValueError("Omega_m out of emulator range.")

        if self.omega_b < 0.0215 or self.omega_b > 0.0235:
            raise ValueError("Omega_b out of emulator range.")

        if self.sigma_8 < 0.7 or self.sigma_8 > 0.9:
            raise ValueError("sigma_8 out of emulator range.")

        if self.h < 0.55 or self.h > 0.85:
            raise ValueError("h out of emulator range.")

        if self.n_s < 0.85 or self.n_s > 1.05:
            raise ValueError("n_s out of emulator range.")

        if self.w_0 < -1.3 or self.w_0 > -0.7:
            raise ValueError("w_0 out of emulator range.")

        w_0a = -(self.w_0 + self.w_a)**(-1/4)
        if w_0a < 0.3 or w_0a > 1.29:
            raise ValueError("w_a out of emulator range.")

        if self.omega_nu < 0 or self.omega_nu > 0.01:
            raise ValueError("Omega_nu out of emulator range.")
        