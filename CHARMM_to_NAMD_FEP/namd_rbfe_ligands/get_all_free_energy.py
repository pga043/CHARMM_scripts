import numpy as np

## NAMD FEP with a hybrid topolgy and charge renormalization

with open('complex/fepout/ParseFEP.log', 'r') as f1:
	for line in f1:
		pass
	cmplx_dG  = float(line.split()[6])
	cmplx_ddG = float(line.split()[-1])
	
with open('water/fepout/ParseFEP.log', 'r') as f2:
	for line in f2:
		pass
	water_dG  = float(line.split()[6])
	water_ddG = float(line.split()[-1])

##book-ending results CRN-> FF
book_end_cmplx = np.genfromtxt('book-ending/complex/results.txt', dtype=str)
book_end_water = np.genfromtxt('book-ending/water/results.txt', dtype=str)

sub1_cmplx = [float(book_end_cmplx[0][8]), float(book_end_cmplx[0][10])]
sub2_cmplx = [float(book_end_cmplx[1][8]), float(book_end_cmplx[1][10])]
sub1_water = [float(book_end_water[0][8]), float(book_end_water[0][10])]
sub2_water = [float(book_end_water[1][8]), float(book_end_water[1][10])]

## ddG_FF = ddG_fep_FEP_CRN - dG_SSP_L1 (CRN->FF) + dG_SSP_L2 (CRN->FF)
dG = round(cmplx_dG - water_dG - (sub1_cmplx[0] - sub1_water[0]) + (sub2_cmplx[0] - sub2_water[0]) , 2)
ddG = round(np.sqrt(cmplx_ddG**2 + water_ddG**2 + sub1_cmplx[1]**2 + sub1_water[1]**2 + sub2_cmplx[1]**2 + sub2_water[1]**2 ), 2)

dG_CRN  = round(cmplx_dG - water_dG, 2)
ddG_CRN = round(np.sqrt(cmplx_ddG**2 + water_ddG**2), 2) 

print(f'BAR free energy change sub1->sub2 with CRN charges = {dG_CRN} +/- {ddG_CRN} kcal/mol')
print(f'BAR free energy change sub1->sub2 with FF charges = {dG} +/- {ddG} kcal/mol')
