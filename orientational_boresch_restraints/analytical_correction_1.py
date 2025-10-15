import math
import sys

#https://github.com/MobleyLab/SeparatedTopologies/blob/main/boresch_restraints.py
# for dG2, see this:
#   https://pubs.acs.org/doi/suppl/10.1021/acs.jcim.4c00442/suppl_file/ci4c00442_si_001.pdf

R = 8.31445985 # Gas constant in kcal/mol/K
T = 298.15     # K
RT = R*T

#r      = 20.54  # angstroms
#thetaA = 63.83  # degrees
#thetaB = 93.21  # degrees

## r = angstroms
## thetaA, thetaB  = degrees
## force constants = kcal/(mol*A**2) or, 
##                 = kcal/(mol*rad**2 )

#k_r      = 20
#k_theta  = 675.42
#k_thetab = 20
#k_phia   = 340.05
#k_phib   = 20
#k_phic   = 20

def analytical_Boresch_correction(r0, thA, thB, fc_r, fc_thA, fc_thB, fc_phiA, fc_phiB, fc_phiC, T=298.15):
    #Analytical correction orientational restraints, equation 14 from Boresch 2003 paper doi 10.1021/jp0217839

    K = 0.0019872041    # unit: kcal/(mol*K)
    V = 1661            # unit: (Angstroms)^3, units of volume

    thA = math.radians(thA)  # get angle in radians
    thB = math.radians(thB)  # get angle in radians

    # dG for turning Boresch restraints off (switch sign if you want to turn them on)
    dG1 = - K * T * math.log(((8.0 * math.pi ** 2.0 * V) / (r0 ** 2.0 * math.sin(thA) * math.sin(thB))
            *
            (((fc_r * fc_thA * fc_thB * fc_phiA * fc_phiB * fc_phiC) ** 0.5) / ((2.0 * math.pi * K * T) ** (3.0)))))

    dG2 = - K * T * math.log(((8.0 * math.pi ** 2.0 * V) / (r0 ** 2.0 * math.sin(thA) * math.sin(thB))
            *
            (((fc_r * fc_thA * fc_thB * fc_phiA * fc_phiB * fc_phiC) ** 0.5) / ((math.pi * K * T) ** (3.0)))))

    #dG in kcal mol
    return dG1, dG2

# read the values from variables file
variables = {}

with open(sys.argv[1], "r") as file:
    for line in file:
        line = line.strip()
        if line.startswith("SET"):
            parts = line.split("=")
            if len(parts) == 2:
                key = parts[0].replace("SET", "").strip()
                value = parts[1].strip()
                try:
                    value = float(value)
                except ValueError:
                    pass
                variables[key] = value

# Map relevant variables to required names
r = variables.get("DISTANCEL1P1")
thetaA = variables.get("THETA1")
thetaB = variables.get("THETA2")
k_r = variables.get("DISTANCEK")
k_theta = variables.get("THETA1K")
k_thetab = variables.get("THETA2K")
k_phia = variables.get("PHI1K")
k_phib = variables.get("PHI2K")
k_phic = variables.get("PHI3K")

# Print the results
print(f"r = {r}")
print(f"thetaA = {thetaA}")
print(f"thetaB = {thetaB}")
print(f"k_r = {k_r}")
print(f"k_theta = {k_theta}")
print(f"k_thetab = {k_thetab}")
print(f"k_phia = {k_phia}")
print(f"k_phib = {k_phib}")
print(f"k_phic = {k_phic}")

dG_off_analytical = analytical_Boresch_correction(r, thetaA, thetaB, k_r, k_theta, k_thetab, k_phia, k_phib, k_phic, T=298.15)

print(f'dG_off_analytical (turning off the restraints) : {round(dG_off_analytical[0], 3)} kcal/mol')
print(f'dG_off_analytical (turning off the restraints) CHARMM format restraint: {round(dG_off_analytical[1], 3)} kcal/mol')


