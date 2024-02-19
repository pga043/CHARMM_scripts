import sys, os

"""
Parveen Gartan
7 February  2024
"""

##------ user needs to define these -------##
prot = '3p0l'
segid = 'PROA'
ter =  ['NTER', 'CTER']
aspp = [190, 180]
glup = [11, 12]
disu = [[29, 45], [125, 82]]


##----- CHARMM input script ---------------##
##----- run it as: ------------------------##
##----- $charmm -i setup.inp > setup.out --##
try:
   os.remove('test.inp')
except FileNotFoundError:
    print('CHARMM protein setup file does not exists.')

f1 = open('test.inp' , 'a')

f1.write(f"""* Run Segment Through CHARMM
* 

read rtf card name toppar/top_all36_prot.rtf
read param card flex name toppar/par_all36m_prot.prm

read sequ pdb name {prot}.pdb

! now generate the PSF and also the IC table (SETU keyword), {segid} is SEGID defined by me
generate setu {segid} first {ter[0]} last {ter[1]} 
\n """)

try:
    aspp[0]
    f1.write(f'!change protonation state of ASP (ASPP is present in top_all36_prot.rtf) \n')
    for asp in range(len(aspp)):
        f1.write(f'patch aspp {segid} {aspp[asp]} setup \n')
except IndexError:
    f1.write(f'\n')

f1.write(f'\n')

try:
    glup[0]
    f1.write(f'!change protonation state of GLU (GLUP is present in top_all36_prot.rtf) \n')
    for glu in range(len(glup)):
        f1.write(f'patch glup {segid} {glup[glu]} setup \n')
except IndexError:
    f1.write(f'\n')

f1.write(f'\n')

try:
    disu[0]
    f1.write(f'! Handle disulfide patching! \n')
    for cys in range(len(disu)):
        f1.write(f'patch disu {segid} {disu[cys][0]} {segid} {disu[cys][1]} setup \n')
except IndexError:
    f1.write(f'\n')

f1.write(f""" \n
!! Be careful if the sequence in the pdb file doesn not start from 1
!! use offset -xxx, xxx - start of sequence in pdb file
!! or use "resi" while reading coordinates

! set bomlev to -1 to avois sying on lack of hydrogen coordinates
bomlev -1
read coor pdb resi name {prot}.pdb 
! them put bomlev back up to 0
bomlev 0

! prints out number of atoms that still have undefined coordinates.
define test select segid {segid} .and. ( .not. hydrogen ) .and. ( .not. init ) show end

ic para
ic fill preserve
ic build
hbuild sele all end

! check if there are unknown coordinate
define XXX sele .not. INIT show end
if ?nsel .gt. 0 stop ! ABNORMAL TERMINATION: Undefined coordinates

write psf card name {prot}.psf
write coor card name {prot}.crd
write coor pdb name {prot}_charmm.pdb

calc cgtot = int ( ?cgtot )

stop""")

