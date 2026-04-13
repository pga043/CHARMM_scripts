# This file is phipsi.awk
# Useage, awk -f phipsi.awk <file.in >file.out
# Extracts phi and psi angles from internal coordinate table
# Output can be opened in spreadsheet 
# Final two columns can be used as chart input to x-y plot 
# Enter the no. residues in the while loop before running

# Read entire set of phi and psi values into list, 
#  taking residue no from CA and phi or psi from column 12
{
	{if ($3 == "C" && $5 == "N" && $7 == "CA" && $9 == "C" )
		phipsi[$6, 1] = $12}
	{if ($3 == "N" && $5 == "CA" && $7 == "C" && $9 == "N" )
		phipsi[$4, 2] = $12}
} 
# After completing list, print it out
END {
	i=1
	while(i<162)
	{	
		printf  "%3d" "%5s" "%5s" "%10s" "%10s\n", \
                    i, "phi", "psi", phipsi[i, 1],  phipsi[i, 2] 
		i++
	}
    }	
