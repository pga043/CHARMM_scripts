import os, glob, sys
import rdkit
from rdkit import Chem

ref = Chem.MolFromSmarts('[CX3]=[OX1]')

mols = [sys.argv[1]]

try:
   os.remove('lig_donors.txt')
except FileNotFoundError:
    print('File does not exists.')


for mol in mols:
    mol2 = Chem.MolFromMol2File(mol, removeHs=False)
    try:
        atoms = list(Chem.Mol.GetSubstructMatches(mol2, ref, uniquify=True)[0])
        #print(mol, atoms[0]+1, atoms[-1]+1)
        an1 = mol2.GetAtomWithIdx(atoms[0]).GetProp('_TriposAtomName')
        an2 = mol2.GetAtomWithIdx(atoms[-1]).GetProp('_TriposAtomName')
        with open('lig_donors.txt', 'a') as f1:
            f1.write(f'set atom1 = {an1}\n')
            f1.write(f'set atom2 = {an2}')
    except IndexError:
        print('Molecule does not contain C=O')
