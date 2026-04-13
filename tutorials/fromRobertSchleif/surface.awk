# This file is surface.awk
# Usage, awk -f surface.awk <file.in >file.out.
# Sums surface area for each residue, outputs residue name, 
# residue number, and total area.
# Enter resum of first residue below.

BEGIN {resnum = 7}
{
  if ( $4 == resnum){
     resname = $3
     s+= $7 
  }
  else {  
     print resname ", ", resnum ", ", s
     s = $7
     resnum++
  }
	endif
}
END {print resname ", ", resnum ", ", s}

