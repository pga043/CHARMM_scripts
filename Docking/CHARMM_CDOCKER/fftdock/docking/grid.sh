#!/bin/bash/

## parameters for the position and size of the grid
space=0.5
x_center=`cat ../hne/xcen`
y_center=`cat ../hne/ycen`
z_center=`cat ../hne/zcen`
max_len=`cat maxlen`

dir=hne
enzyme=hne

## parameters for hard core potential
emax=100
mine=-100
maxe=100
$charmm space=$space xcen=$x_center ycen=$y_center zcen=$z_center xmax=$max_len\
 emax=$emax mine=$mine maxe=$maxe dir=$dir enzyme=$enzyme < genGrid.inp > genGrid.out 

## parameters for hard core potential -- SA
emax=3
mine=-30
maxe=30
$charmm space=$space xcen=$x_center ycen=$y_center zcen=$z_center xmax=$max_len\
 emax=$emax mine=$mine maxe=$maxe dir=$dir enzyme=$enzyme < genGrid.inp > genGrid.out 


