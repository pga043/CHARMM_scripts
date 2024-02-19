import rdkit
from rdkit import Chem
from rdkit.Chem import AllChem
import glob, os

suppl = Chem.SDMolSupplier('Spiro_piperazinones_TILD_V2.sdf')

#x = 0
#for mol in suppl:
#    molh = Chem.AddHs(mol)
#    with Chem.SDWriter(f'junk_{x}.sdf') as writer:
#        confIds = Chem.AllChem.EmbedMultipleConfs(molh, 1)
#        for confId in range(100):
#            Chem.AllChem.UFFOptimizeMolecule(molh, confId=confId)
#        writer.write(molh, confId=confId)
#    x += 1


x = 8
confs = 100
for mol in suppl:
    molh = Chem.AddHs(mol)
    confIds = Chem.AllChem.EmbedMultipleConfs(molh, confs)
    score = []
    for confId in range(confs):
        Chem.AllChem.UFFOptimizeMolecule(molh, confId=confId)
        ff = AllChem.UFFGetMoleculeForceField(molh, confId=confId)
        score.append(ff.CalcEnergy())
        print(ff.CalcEnergy())
    minE = min(score, key=abs)
    print(minE)
    with Chem.SDWriter(f'sprios_dec_{x}.sdf') as writer:
         writer.write(molh, confId=int(score.index(minE)))
    print('-------------')
    with open(f'sprios_dec_{x}.pdb', 'w') as f:
         pdb = Chem.MolToPDBBlock(molh, confId=int(score.index(minE)), flavor=4)
         pdb = Chem.AtomPDBResidueInfo()
         pdb.SetResidueName('MOL')
         f.write(pdb)
    x += 1


#pdbblock = Chem.MolToPDBBlock(mh)
#open("/tmp/noh.pdb",'w').write(Chem.MolToPDBBlock(mh, flavor=4))
    
