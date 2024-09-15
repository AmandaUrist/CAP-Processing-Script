# CAP Processeing Script

## Files
Script to calculate CAP from mass data and spectrophometric readings (Urist et al., 2024)

To run the script you will need the following files:

#### (1) Mass Data Excel File - 6.20.24_dissolved.xlsx

A file with rows of sample ID, mass dissolved, fraction dissolved, and total volume of solution if not 3 ml (See methods of manuscript) 

#### 2) Spectophotometry Reading - 6.20.24.xlsx

A file with reading from spectrophotometer. 

        - First row and column are well identifiers
        - The calibration curve is A1:B7
        - Milli-Q Water blanks are A8-10
        - Triplicate sample absorbances are split between each column and rows D-E and F-H 

#### (3) CAP Calculation R Script - Base.Fluro.Reading.R

Script that reads in files listed above, calculates CAP from spectromotometric readings and digested carbonate masses. 

#### (4) NaCl Mass Data Excel File - 6.20.24_NaCldissolved.xlsx

A file with rows of sample ID, mass dissolved, and fraction dissolved. 

Data in this file will be the same as the first download 6.20.24_dissolved.xlsx except the order of samples may be different and the total volume of solution is not needed. 

#### (5) Spectophotometry Reading - 6.20.24_NaCl.xlsx

A file with reading from spectrophotometer. 

        - First row and column are well identifiers
        - The calibration curve is A1:B7
        - Milli-Q Water blanks are A8-10
        - Triplicate sample absorbances are split between each column and rows D-E and F-H 

#### (5) NaCl CAP Calculation R Script - Base.Fluro.NaCl.Reading.R

Script that reads in files listed above, calculates CAP from spectromotometric readings and digested carbonate masses after NaCl rinses. 

### Order of the Mass and Spectrophotometer Data
R reads in the spectrophotometer triplicate data starting in line 37 in the following order: 

![PCycle](https://github.com/user-attachments/assets/afc886f9-84f1-40cc-a67c-0a884ea6e085)


The mass data excel files need to be in order from sample #1-24, where samples #1-12 are from the spectrophotometer data C1:E12, and samples #13-24 are from F1:H12. 

## Liscense
You can freely use and modify the code, without warranty, so long as you provide attribution to the authors.

The manuscript text is not open source. The authors reserve the rights to the article content, which is currently submitted for publication in the JOURNAL NAME.
