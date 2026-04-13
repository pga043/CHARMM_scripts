# This file is phi.awk
# Usage, awk -f phi.awk <file.in >file.out.
# Extracts phi from internal coordinate file.
 
{
	if ($3 == "C" && $5 == "N" && $7 == "CA" && $9 == "C" )
	{
		printf "%3s" "%5s" "%10s\n", "phi", $6, $12
	}
}

