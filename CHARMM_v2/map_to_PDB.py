#!/usr/bin/env python3

import sys
import numpy as np


"""
Map RMSF or other data to PDB
"""

__author__ = "Emmanuel Edouard MOUTOUSSAMY"
__version__  = "1.0.0"
__date__ = "2020/08"
__copyright__ = "CC_by_SA"
__dependencies__ = ""




def read_data(rms_data):

    dico_all = {}
    dico_bb = {}
    dico_sc = {}


    with open(rms_data) as inputfile:
        for line in inputfile:
            if "#" not in line:
                line = line.split()
                if line != []:
                    dico_all[int(line[0])] = float(line[1])
                    dico_bb[int(line[0])] = float(line[2])
                    dico_sc[int(line[0])] = float(line[3])

    return dico_all,dico_bb,dico_sc

def Mapped(pdb,dico,outname):
    """
    Map the dist. on a pdb file
    :param pdb: a PDB file of a protein/membrane complex
    :param dico: dico containing data to change
    :param outname: name of output
    :return: write a pdb file with the new dada as the B-factor
    """

    pdbout = pdb.replace(".pdb","_mapped_%s.pdb"%outname)

    output = open(pdbout,"w")

    with open(pdb) as inputfile:
        for line in inputfile:
            if "ATOM" in line:
                resid = int(line[22:26])
                extend = line[46:].replace(line[60:66],"%6.2f"%dico[resid])
                line = "%s%s"%(line[0:46],extend)
                line = line.replace("HSD","HIS")
                line = line.replace("HSE","HIS")
                output.write(line)



if __name__ == '__main__':

    dico_all, dico_bb, dico_sc = read_data(sys.argv[1])

    Mapped(sys.argv[2],dico_all,"all") #write all
    Mapped(sys.argv[2],dico_bb,"bb") #write BB
    Mapped(sys.argv[2], dico_sc, "sc")  # write SC


