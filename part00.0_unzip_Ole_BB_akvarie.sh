#!/bin/bash
#SBATCH --account=hologenomics         # Project Account
#SBATCH --partition=hologenomics 
#SBATCH --mem 128M
#SBATCH -c 1
#SBATCH -t 4:00:00
#SBATCH -J 00A_fetch_file
#####  ##SBATCH -o stdout_00.0_unzip.txt
#####  ##SBATCH -e stderr_00.0_unzip.txt

#load modules required
module purge
#module load python/v2.7.12
#module load cutadapt/v1.11
#module load vsearch/v2.8.0

#Get file from ERDA
#
unzip Ole_MIFISH12S_PCR1_4_Aquarium.zip