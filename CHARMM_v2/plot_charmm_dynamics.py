import sys, os
import numpy as np
import matplotlib.pyplot as plt

dyna = open(sys.argv[1], 'r')

"""
DYNA DYN: Step         Time      TOTEner        TOTKe       ENERgy  TEMPerature
"""

def inst_pressure(ke, virial, vol):
    pressure = ( 2/3 * ke + 1/3 * virial) / vol 
    return pressure 

steps  = []
energy = []
temp   = []
volume = []
press  = []
for lines in dyna:
    if lines.startswith('DYNA>'):
        line = lines.split()
        ener = line[3].split('-')[-1]
        steps.append(float(line[1]))
        energy.append(-float(ener))
        temp.append(float(line[-1]))
        #ke = float(line[3].split('-')[0])
    if lines.startswith('DYNA PRESS>'):
        line = lines.split()
        #print(line)
        vol = float(line[-1])
        volume.append(vol)
        #virial = float(line[3])
        #pressure = inst_pressure(ke, virial, vol)
        #print(pressure)
        #press.append(pressure)

# Create figure and 6 subplots
fig, ax = plt.subplots(nrows=2, ncols=2, figsize=(10, 6))

ax[0,0].plot(energy, label="potential energy")
#ax[0, 0].set_title('')
ax[0,0].legend(frameon=False)

ax[0,1].plot(temp, label="temp")
ax[0,1].legend(frameon=False)

ax[1,0].plot(volume, label="volume")
ax[1,0].legend(frameon=False)

#ax[1,1].plot(press, label="pressure")
#ax[1,1].legend(frameon=False)

#ax[0].set_ylim([min(energy), max(energy)])
#ax[1].set_ylim([min(temp), max(temp)])

ax[1,0].set_xlabel("nsteps")
ax[0,1].set_xlabel("nsteps")

# Set overall title and tight layout
fig.suptitle("CHARMM heating run")
fig.tight_layout()

# Show the plot
#plt.savefig('heating.png', dpi=600)
plt.show()

quit()
