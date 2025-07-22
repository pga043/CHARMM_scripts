import os, sys

import rdkit
from rdkit import Chem
from rdkit.Chem import AllChem

import Mol2writer

inp_mol   = sys.argv[1] 
out_mol = sys.argv[2]

##***************************************
inp = Chem.SDMolSupplier(inp_mol, removeHs=False)
mol = inp[0]

Mol2writer.MolToMol2File(mol, str(out_mol) + '.mol2', confId=-1)

quit()

def sdf2mol2(sdf, mol2):
    suppl = Chem.SDMolSupplier(sdf, removeHs=False)

    for mol in suppl:
        molh = Chem.AddHs(mol, addCoords = True)

    Mol2writer.MolToMol2File(molh, mol2, confId=-1)

sdf2mol2(sys.argv[1], sys.argv[2])
