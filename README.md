# CHARMM_scripts
These files can be used to prepare a protein ligand complex including crystal waters for CHARMM.
Then the complexed systems can be solvated, neutralized, minimized, heated.
After that MD simulations can be run either with NAMD or CHARMM (including openMM, BLaDE or domdec_gpu).

Note: water.crd is equilibrated water layer obtained from: https://www.charmm.org/wiki//index.php/CHARMM_Tutorial

For someone not familiar with CHARMM, I think the two important files/directories are: \
[tutorials](https://github.com/pga043/CHARMM_scripts/tree/main/tutorials) and charmm_tutorial_2010.pdf

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

# Restraints and Engine compatability
| Restraint  | Domdec | BLaDE | CHARMM/OpenMM |
| ------------- | ------------- | ------------ | ------------ |
| NOE  | Supported  | Supported | No |
| MMFP  | on CPU  | only pair of atoms (Boresch type supported) | Some by Charlie and Argo |
| RESD  | -  | - | Supported |
| IC  | -  | - | - |
| RMSD  | No  | No | No |
| Cons Harm  | Supported  | No | didn't test |
| CATS  | Supported  | Supported | Not sure |

# Soft-core potentials and other FF related stuff
| Feature  | Domdec | BLaDE | CHARMM/OpenMM |
| ------------- | ------------- | ------------ | ------------ |
| non-integer e14fac  | Supported  | Supported | Supported |
| Geometric combination rules | Supported  | Supported | ask Charlie |
| Periodic type improper torsions (eg. AMBER)  | -  | Supported | - |
| Soft Core  | soft on  | soft on | somm |
| Double exponential potential  | -  | - | - |

# Mixing force fields:
CHARMM/OPLS \
Things to look for: \
Combination rules : this can be taken care of by using either scalar or NBFIX (as I understand the role of NBFIX is to override the standard arithmetic combination rule for a
selected atom pair, for more information see:10.1021/jp401512z) \
e14fac = according to Charlie, there is no rationale as to why the interactions are scaled down (at least that’s what I understood)
		can be taken care of by using the scalar command (scalar e14fac set 0.5/1/0 select xxx end)

# CHARMM Errors and Potential Solutions:
Maximum number of dihedrals reached error:\
With the new version of CGenFF (v 5.0), I am getting the following error after reading par_all36_cgenff.prm

***** LEVEL -3 WARNING FROM <PARRDR> ***** \
***** Maximum no. of dihedrals reached \
****************************************** \
BOMLEV ( 0) IS REACHED - TERMINATING. WRNLEV IS 5

Solution: \
The error can be solved by increasing the following array sizes (suggestion received from silcsbio): 

MAXCP 100000 \
MAXNBF 400000 

in

charmm/source/ltm/dimens_ltm.F90





