# This file is enrotate.awk.
# Usage, awk -f enrotate.awk <filein >fileout
# For rotation and/or translation of coordinates in pdb format files and  
#   reporting coordinate limits.
# Replace rotation/translation matrix elements with appropriate numeric values.

BEGIN  {
	FIELDWIDTHS=" 6 24 8 8 8 22"
	init=0 
	}
{
	if ($1 != "ATOM  " && $1 != "HETATM" ) 
		print $0
	else
	{
		x= a00*$3 + a01*$4 + a02*$5 + a03 
		y= a10*$3 + a11*$4 + a12*$5 + a13 
		z= a20*$3 + a21*$4 + a22*$5 + a23
		printf "%6s%24s%8.3f%8.3f%8.3f%-22s\n", $1, $2, x, y, z, $6 
		if (init==0)
		{
			xmin=x
			xmax=x
			ymin=y
			ymax=y
			zmin=z
			zmax=z
			init=1
		}
		if (init == 1)
		{
			if (x < xmin)
				xmin=x
			if (x > xmax)
				xmax=x
			if (y < ymin)
				ymin=y
			if (y > ymax)
				ymax=y
			if (z < zmin)
				zmin=z
			if (z > zmax)
				zmax=z
		}
	}
		
}
END {print "xmin=" xmin ", xmax= "xmax "  ymin="ymin ", ymax=" ymax \
  "  zmin=" zmin ", zmax=" zmax > "/dev/tty" }	
