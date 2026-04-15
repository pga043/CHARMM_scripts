import sys
import numpy as np

r1 = 1 
r2 = 6
emax = -7.5
r = 4

Ecov = (-4 * emax / ((r2-r1)^2) ) * (r - r1) * (r-r2)

print("rmax: " + str(r2) + ", r: " + str(r))
print("Covalent grid point energy (kcal/mol): " '{0:.2f}'.format(Ecov))
