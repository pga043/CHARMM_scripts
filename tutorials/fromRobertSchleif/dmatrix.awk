# This file is dmatrix.awk.
# Usage, awk -f dmatrix.awk <data.in >file.out.
# To extract distances between all pairs in data.in.
#  and output comma delimited lines suitable for spreadsheet input.
# Input data is num1 num2 num3 where num3 is distance between num1 atom and 
#  num2 atom.
# Enter the array dimensions in the while loops before running.

# Read entire dataset into two dimensional energy array.
 { dist[$1,$2] = $3 }

# At end, print out comma delimited array elements on separate lines

END { 
	i=1
	j=1
	while(i<162)
	{
		while(j<162)
		{
			printf(dist[i,j], "," )
			j++
		}
		printf("\n")
		j=1
		i++
	}
  }

