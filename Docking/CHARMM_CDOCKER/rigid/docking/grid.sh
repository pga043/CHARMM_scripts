#!/bin/bash/

## parameters for the position and size of the grid
space=0.5
#x_center=`cat ../sim-hne/xcen`
#y_center=`cat ../sim-hne/ycen`
#z_center=`cat ../sim-hne/zcen`

#max_len=`cat maxlen`
rcta=`echo 0`
rctb=`echo 1`
hmax=`echo 0`

## parameters for hard core potential
emax=100
mine=-100
maxe=100
$charmm space=$space xcen=$x_center ycen=$y_center zcen=$z_center xmax=$max_len\
 emax=$emax mine=$mine maxe=$maxe rcta=$rcta rctb=$rctb hmax=$hmax prot=$prot enzyme=$enzyme < ../genGrid.inp > genGrid.out

## parameters for hard core potential -- SA
emax=3
mine=-30
maxe=30
$charmm space=$space xcen=$x_center ycen=$y_center zcen=$z_center xmax=$max_len\
 emax=$emax mine=$mine maxe=$maxe rcta=$rcta rctb=$rctb hmax=$hmax prot=$prot enzyme=$enzyme < ../genGrid.inp >> genGrid.out

## parameters for hard core potential -- SA
emax=0.6
mine=-0.4
maxe=0.4
$charmm space=$space xcen=$x_center ycen=$y_center zcen=$z_center xmax=$max_len\
 emax=$emax mine=$mine maxe=$maxe rcta=$rcta rctb=$rctb hmax=$hmax prot=$prot enzyme=$enzyme < ../genGrid.inp >> genGrid.out

