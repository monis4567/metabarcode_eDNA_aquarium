#!/bin/bash
# -*- coding: utf-8 -*-

#put present working directory in a variable
WD=$(pwd)
#REMDIR="/groups/hologenomics/phq599/data/EBIODIV_2021jun25"
REMDIR="${WD}"
#define input directory
OUDIR01="01_demultiplex_filtered"

#define path for b_library numbers
PATH01=$(echo ""${REMDIR}"/"${OUDIR01}"")

# #prepare paths to files, and make a line with primer set and number of nucleotide overlap between paired end sequencing
# Iteration loop over b library numbers
# to prepare slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
NOS=$(seq -f "%03g" 1 4)
#iterate over numbers to add PCR to the number for each number
PCRNOS=$(for e in $NOS; do echo "PCR"$e; done)
# make an array
ARRL=(L1 L4)
#loop through the array - only needed to test it out
#for l in ${ARRL[@]}; do echo $l; done 

#iterate over PCR numbers
for fn in $PCRNOS
do
	#iterate over L array
 	for fl in ${ARRL[@]}
 	do	
		#echo $fn
		
		#make a directory name for the NGS library
		BDR=$(echo "b"${fn}"_"${fl}"")
			
	#also replace in the slurm submission script
	cat part04_run_02blast_global_v01.sh | \
	# and use sed to replace a txt string w the b library number
	# replace "blibrarynumber"
	sed "s/blibnumber/b"${fn}"/g" |
		sed "s/Lnumber/"${fl}"/g" > "${PATH01}"/"${BDR}"/part04_run_02blast_global_v01_b"${fn}"_"${fl}".sh
	
# end iteration over sequence of numbers	
done
done

# Iteration loop over b library numbers
# to prepare slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
NOS=$(seq -f "%03g" 1 4)
#iterate over numbers to add PCR to the number for each number
PCRNOS=$(for e in $NOS; do echo "PCR"$e; done)
# make an array
ARRL=(L1 L4)
#loop through the array - only needed to test it out
#for l in ${ARRL[@]}; do echo $l; done 

#iterate over PCR numbers
for fn in $PCRNOS
do
	#iterate over L array
 	for fl in ${ARRL[@]}
 	do	
		#echo $fn
		
		#make a directory name for the NGS library
		BDR=$(echo "b"${fn}"_"${fl}"")
			# change directory to the subdirectory
	cd "${PATH01}"/"${BDR}"
	# start the slurm sbatch code
	sbatch part04_run_02blast_global_v01_b"${fn}"_"${fl}".sh
	# change directory to the working directory
	cd "${WD}"
# end iteration over sequence of numbers	
done

done
#
#
#
#NJOBS=$(seq 30093662 30093668); for i in $NJOBS; do scancel $i; done
