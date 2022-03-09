#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#set working directory
wd00 <- "/home/hal9000/Documents/shrfldubuntu18/Akvarie_Ole_eDNA"
setwd(wd00)

#install packages
#get readxl package
if(!require(readxl)){
  install.packages("readxl")
}  
library(readxl)
#define input files
inf1 <- "MiFish_tagged_primers_96tags.xlsx"
inf2 <- "Sample_list_metadata_v5.xlsx"
#read in excel files
tibl_MF01    <- readxl::read_xlsx(inf1, col_names =T)
tibl_SM01    <- readxl::read_xlsx(inf2, col_names =T)
# make tibbles data frames
df_MF01 <- as.data.frame(tibl_MF01)
df_SM01 <- as.data.frame(tibl_SM01)
#pad with zeros to 3 characters
#see this website: https://stackoverflow.com/questions/5812493/adding-leading-zeros-using-r
df_SM01$smpNopd <-stringr::str_pad(df_SM01$Sample_number, 3, pad = "0")
#match between data frames to get sample number
df_MF01$smpNopd <- df_SM01$smpNopd[match(df_MF01$`Well Position`,df_SM01$PCR_well)]
#paste SN in front of sample No to denote it is sample number
df_MF01$smpNopd2 <- paste("SN",df_MF01$smpNopd,sep="")
#split column as string and retain first and third column
df_MF01$prmset <- data.frame(do.call('rbind', strsplit(as.character(df_MF01$`Plate Name`),'_',fixed=TRUE)))[,1]
df_MF01$tagNo <- data.frame(do.call('rbind', strsplit(as.character(df_MF01$`Sequence Name`),'_',fixed=TRUE)))[,3]
#paste SN in front of sample No to denote it is tag number
df_MF01$tagNo <- paste("tag",df_MF01$tagNo,sep="")
#define columns to keep
keep <- c("smpNopd2","prmset","tagNo")
# keep only these columns
df_MF02 <-  df_MF01[keep]
#match to get tag sequence
df_MF02$tagseq1 <- df_MF01$`Sample Tag`[match(df_MF02$tagNo,df_MF01$tagNo)]
df_MF02$tagseq2 <- df_MF02$tagseq1
#paste columns together
df_MF02$smpNopd3 <- paste(df_MF02$smpNopd2,
                          df_MF02$prmset,
                          df_MF02$tagNo,
                          sep="_")
#define columns to keep
keep <- c("smpNopd3","tagseq1","tagseq2")
# keep only these columns
df_MF03 <-  df_MF02[keep]
#write out the tag file
write.table(df_MF03, file="part01A_tag01_96_MiFiU_AkvarieOleB.txt",
          sep="\t",
          col.names = F,
          row.names = F,
          quote=F
          )


#