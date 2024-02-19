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
