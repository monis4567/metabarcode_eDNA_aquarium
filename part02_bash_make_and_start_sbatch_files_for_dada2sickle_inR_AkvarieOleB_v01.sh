#!/bin/bash
# -*- coding: utf-8 -*-

#put present working directory in a variable
WD=$(pwd)
REMDIR="/groups/hologenomics/phq599/data/Akvarie_Ole_eDNA_analyse"
#define input directory
OUDIR01="01_demultiplex_filtered"

#define path for b_library numbers
PATH01=$(echo ""${REMDIR}"/"${OUDIR01}"")

# #prepare paths to files, and make a line with primer set and number of nucleotide overlap between paired end sequencing
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
# do this for 001 to 004 for the MiFiU primerset
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
		# write the contents with cat
		cat part02_sbatch_run_dada2_sickle_R_v01.sh | \
		# and use sed to replace a txt string w the b library number
		sed "s/blibnumber/b"${fn}"/g" |
		sed "s/Lnumber/"${fl}"/g" > "${PATH01}"/"${BDR}"/part02_sbatch_run_dada2_sickle_R_v01_b"${fn}"_"${fl}".sh
		#make the DADA2 sh script executable
		chmod 755 "${PATH01}"/"${BDR}"/part02_sbatch_run_dada2_sickle_R_v01_b"${fn}"_"${fl}".sh

	done
done
