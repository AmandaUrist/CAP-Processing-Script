####################################CAP Calculations#############################
#A program that calculates CAP from spectrophotometry readings and digested carbonate masses
#Author: Cole Stern
#Edited by Miquela Ingalls and Amanda Urist 

#Read in libraries.
library(readr)
library(tidyverse)
library(vegan)
library(caTools)
library(dplyr)
library(ggpmisc)
library(readxl)

#Read in the data files where its saved in your own files
setwd("C:/Users/CAPReadings")

#The spectro file is the .xlsx exported from Gen5 software (plate reader)
spectro <- read_xlsx("6.20.24.xlsx")

#The dissolved file reads in the sample names, the grams of carbonate dissolved, percent dissolved, and total volume if <3 ml.
dissolved <- read_xlsx("6.20.24_dissolved.xlsx") 

#Make data files dataframes and identify sample IDs
spectro.frame <- data.frame(spectro)
dissolved.frame <- as.data.frame(dissolved)
colnames(dissolved.frame) <- colnames(dissolved)

#Separate out samples from initial spectro.frame
samplenames <- colnames(dissolved.frame)

#Extract the fraction dissolved data and volume of solution in falcon tube if less than 3 ml (will be NA if 3 ml)
fraction_dissolved <- as.numeric(dissolved[2, ])

#Reading in wells and assigning the triplicate readings
row1 <- list(spectro.frame[3,2], spectro.frame[3,3], spectro.frame[3,4],spectro.frame[3,5],
             spectro.frame[3,6], spectro.frame[3,7], spectro.frame[3,8], spectro.frame[3,9],
             spectro.frame[3,10], spectro.frame[3,11], spectro.frame[3,12],spectro.frame[3,13],
             spectro.frame[6,2], spectro.frame[6,3],spectro.frame[6,4],spectro.frame[6,5],
             spectro.frame[6,6],spectro.frame[6,7],spectro.frame[6,8],spectro.frame[6,9],
             spectro.frame[6,10],spectro.frame[6,11],spectro.frame[6,12],spectro.frame[6,13])

row2 <- list(spectro.frame[4,2], spectro.frame[4,3], spectro.frame[4,4],spectro.frame[4,5],
             spectro.frame[4,6], spectro.frame[4,7], spectro.frame[4,8], spectro.frame[4,9],
             spectro.frame[4,10], spectro.frame[4,11], spectro.frame[4,12],spectro.frame[4,13],
             spectro.frame[7,2],spectro.frame[7,3],spectro.frame[7,4],spectro.frame[7,5],
             spectro.frame[7,6],spectro.frame[7,7],spectro.frame[7,8],spectro.frame[7,9],
             spectro.frame[7,10],spectro.frame[7,11],spectro.frame[7,12],spectro.frame[7,13])

row3 <- list(spectro.frame[5,2], spectro.frame[5,3], spectro.frame[5,4],spectro.frame[5,5],
             spectro.frame[5,6], spectro.frame[5,7], spectro.frame[5,8], spectro.frame[5,9],
             spectro.frame[5,10], spectro.frame[5,11], spectro.frame[5,12],spectro.frame[5,13],
             spectro.frame[8,2],spectro.frame[8,3],spectro.frame[8,4],spectro.frame[8,5],
             spectro.frame[8,6],spectro.frame[8,7],spectro.frame[8,8],spectro.frame[8,9],
             spectro.frame[8,10],spectro.frame[8,11],spectro.frame[8,12],spectro.frame[8,13])

#Create a table of just the sample absorbance values where each column has triplicate analyses of one sample.
samplevalues <- cbind(row1,row2,row3)
samplevalues <- data.frame(samplevalues)


#Remove row names and change column names to sample IDs.
rownames(samplevalues) <- samplenames
colnames(samplevalues) <- NULL
samplevalues2 <- sapply(samplevalues, as.numeric)
samplevalues2 <- as.data.frame(samplevalues2)

#Counts the number of replicate absorbance values, typically 3 unless you 
#have deleted an absorbance value because of a poor analysis (e.g. bubbles, 
#extra molybdate reagent added, contamination, etc.). It is critical that you 
#take notes on WHY an absorbance measurement is excluded.

n <- rowSums(!is.na(samplevalues2))

#Get averages from the three readings of each samples
data.avg <- rowMeans(samplevalues2, na.rm = TRUE)
print(data.avg)

#Get standard deviation from each samples
data.sd <- apply(samplevalues2, 1, sd, na.rm = TRUE)


#Subtract the blank value from the averages
blank <- ((spectro.frame[1,9])+(spectro.frame[1,10])+(spectro.frame[1,11]))/3
data.avg.true <- (data.avg - blank)

#Make a data summary table
data.summary <- rbind(samplenames, data.avg, data.avg.true, n, data.sd)
rownames(data.avg.true) <- NULL
data.summary <- as.data.frame(data.summary)

#Compute the nmol P in the wells
#To do this we need the linear regression of the standards
standard = list(0.5,1,2,3,4,5,6)

#Read in the absorbance values for your standards. Only run one of the two lines below for "value".
#IF YOU HAVE TWO GOOD SETS OF STANDARDS:
value = list(((spectro[1,2]+spectro[2,2])/2-blank),((spectro[1,3]+spectro[2,3])/2-blank),((spectro[1,4]+spectro[2,4])/2-blank),
             ((spectro[1,5]+spectro[2,5])/2-blank),((spectro[1,6]+spectro[2,6])/2-blank),((spectro[1,7]+spectro[2,7])/2-blank),
            ((spectro[1,8]+spectro[2,8])/2-blank))

#IF YOU HAVE ONLY ONE GOOD SET OF STANDARDS:
#value = list((spectro[1,2]-blank),(spectro[1,3]-blank), (spectro[1,4]-blank),
 #            (spectro[1,5]-blank),(spectro[1,7]-blank),
  #          (spectro[1,8]-blank))

standardvalues <- list(standard, value)

standard.data<- as.data.frame(matrix(unlist(standardvalues), ncol = length(standardvalues)))

#Check how your standard calibration curve looks

ggplot(standard.data, aes(V1,V2)) +
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2"))) +
  xlab("nmol P") +
  ylab("absorbance at 650 nm") +
  geom_point() +
  theme_classic()

#Second, run the linear regression for the standards
lm.r = lm(formula= V2 ~ V1 , data = standard.data)
cf <- coef(lm.r)


Intercept <- cf[1]
Slope <- cf[2]

#Third, compute the nmol P in each well (200 ul)
well_nmolp <- (data.avg.true-Intercept)/Slope

#Fourth, compute the nmol P in the original digestion solution, 3 ml or <3 ml
lu_nmolp <- ifelse(is.na(total_volume), well_nmolp * 15, well_nmolp * (total_volume * 1000 / 200))

#Fifth, compute the umol P/g CaCO3
umolp_g <- t(t(lu_nmolp) * (10^-3)) / as.numeric(dissolved[1,])

#Sixth, compute mmol P/mol calcite
mmolp_molcalc <- (umolp_g/1000)*100.0869

#Seventh, compute mmol P/mol dolomite
mmolp_moldol <- ((umolp_g/1000)*184.401)/2

#Finish with the standard deviation of CAP values
sd_p_calcite  <- abs(((((((data.avg.true + data.sd - Intercept) / Slope) * ifelse(is.na(total_volume), 15, total_volume * 1000 / 200)) * 10^-3) / t(t(as.numeric(dissolved[1,]))))) / 10.00869 - mmolp_molcalc) / sqrt(n)
sd_p_dolomite <- abs(((((((data.avg.true + data.sd - Intercept) / Slope) * ifelse(is.na(total_volume), 15, total_volume * 1000 / 200)) * 10^-3) / t(t(as.numeric(dissolved[1,])))))/ 18.4401 - mmolp_molcalc) / sqrt(n)

#Produce a dataframe with mmol p/mol dolomite, mmol p/mol calcite, and the sample names
df_list <- list(mmolp_molcalc, mmolp_moldol, sd_p)

output <- data.frame(samplenames = samplenames,
                     avg_absorb = data.avg.true,
                     sd_absorb = data.sd,
                     mmolp_molcal = mmolp_molcalc,
                     sd_p_calcite = sd_p_calcite,
                     mmolp_moldol = mmolp_moldol,
                     sd_p_dolomite = sd_p_dolomite,
                     n = n,
                     fraction_dissolved = fraction_dissolved)

#Output table, copy to clipboard, and export to create CSV file
output
write.table(output, "clipboard", sep = "\t", row.names = FALSE, quote = FALSE)
write.csv(output, "6.20.24_datasummary.csv")

