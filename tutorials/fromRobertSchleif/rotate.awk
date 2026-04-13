# This file is rotate.awk.  Should run on UNIX and LINIX
# For rotation and/or translation of coordinates in pdb format files
# Useage, awk -f rotate.awk <filein >fileout
# Rotation/translation matrix elements, aij, must be entered below
# Note that $i refers to the ith column in input file.  If pdb file lacks a
#  subunit identifier, i.e. A, B, C, column is blank, in which case $i entries in
#  "ATOM" section need to be changed to $i-1, i.e. $7, $8, $9 -> $6, $7, $8
# Beware of case, 2ARC.PDB is not 2arc.pdb
# Beware of pdb files where there is no white space between field entries and
#  hetatm types that result in different or variable numbers of entries before
#  the coordinate values

BEGIN  {
       a00 = -1; a01=0; a02=0; a03=0
       a10=0; a11=1; a12=0; a13=0
       a20=0; a21=0; a22=-1; a23=0
       } 
{
    if ($1 == "ATOM" ) 
    {
        x=a00*$7 + a01*$8 + a02*$9 + a03
        y=a10*$7 + a11*$8 + a12*$9 + a13
        z=a20*$7 + a21*$8 + a22*$9 + a23
        printf substr($0,0,31) "%7.3f %7.3f %7.3f %s\n", x, y, z, substr($0,56)  
    }	
    else if ($1 == "HETATM" )
    {

        x=a00*$6 + a01*$7 + a02*$8 + a03
        y=a10*$6 + a11*$7 + a12*$8 + a13
        z=a20*$6 + a21*$7 + a22*$8 + a23
        printf substr($0,0,31) "%7.3f %7.3f %7.3f %s\n", x, y, z, substr($0,56)
     }
        else print $0

}
