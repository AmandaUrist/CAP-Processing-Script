# CAP Processing Script

Script to calculate CAP from mass data and spectrophotometry readings (Urist et al., 2025)

To run the script you will need the following files:

#### 1) Mass Data Excel File - 6.20.24_dissolved.xlsx

A file with rows of sample ID, mass dissolved, and fraction dissolved

#### 2) Spectrophotometry Reading - 6.20.24.xlsx

A file with reading from spectrophotometer. 

        - First row and column are well identifiers
        - The calibration curve is A1:B7
        - Milli-Q Water blanks are A8:10
        - Triplicate sample absorbances are split between each column and rows C-E and F-H 

#### 3) CAP Calculation R Script - Base.Reading.R

Script that reads in files listed above and calculates CAP from spectrophotometer reading and digested carbonate masses. 
- Line 18: Mass data and spectrophotometry plate is read in
- Line 75: Average triplicate absorbance is calculated
- Line 83: Average MQ water blank absorbance is subtracted from the average triplicate absorbance
- Line 92: Plot standard curve from 0.5 to 6 nmol P/well. Sample standard curve from files: 
![Image](https://github.com/user-attachments/assets/b6fdd958-77f5-45ed-b0b9-a1c773b29a0d)
- Line 128: Apply standard curve to sample average absorbance in well plate
- Line 137: Calculate CAP (mmol P/mol calcite, mmol P/mmol dolomite)
- Line 143: Calculate standard deviation 
- Line 147: Create a dataframe of sample ID, average abosrbance, CAP<sub>calcite</sub>, standard deviation<sub>calcite</sub>, CAP<sub>dolomite</sub>, standard deviation<sub>dolomite</sub>, n, fraction dissovled. Sample output from files:
  
![Image](https://github.com/user-attachments/assets/ee64e885-8384-4699-bb88-7611fd92532e)
  - Line 158: Export output dataframe to CSV file
    
#### 4) NaCl Mass Data Excel File - 6.20.24_NaCldissolved.xlsx

A file with rows of sample ID, mass dissolved, and fraction dissolved. 

Data in this file will be the same as the first download 6.20.24_dissolved.xlsx except the order of samples may be different. 

#### 5) Spectrophotometry Reading - 6.20.24_NaCl.xlsx

A file with reading from spectrophotometer. 

        - First row and column are well identifiers
        - The calibration curve is A1:B7
        - Milli-Q Water blanks are A8:A10
        - NaCl blanks are B8:B10
        - Triplicate sample absorbances are split between each column and rows C-E and F-H 

#### 6) NaCl CAP Calculation R Script - Base.NaCl.Reading.R

Script that reads in files listed above and calculates CAP from spectrophotometer reading and digested carbonate masses after NaCl rinses. 
- Line 18: Mass data and spectrophotometry plate is read in
- Line 75: Average triplicate absorbance is calculated
- Line 83: Average NaCl blank absorbance is subtracted from the average triplicate absorbance
- Line 92: Plot standard curve from 0.5 to 6 nmol P/well. Sample standard curve from files: 
![Image](https://github.com/user-attachments/assets/b6fdd958-77f5-45ed-b0b9-a1c773b29a0d)
- Line 128: Apply standard curve to sample average absorbance in well plate
- Line 137: Calculate NaCl CAP reading (mmol P/mol calcite, mmol P/mmol dolomite), and select readings that are positive 
- Line 145: Calculate standard deviation, and select readings that are positive
- Line 147: Create a dataframe of sample ID, average abosrbance, CAP<sub>calcite</sub>, standard deviation<sub>calcite</sub>, CAP<sub>dolomite</sub>, standard deviation<sub>dolomite</sub>, n, fraction dissovled. Sample output from files:
  
![Image](https://github.com/user-attachments/assets/ee64e885-8384-4699-bb88-7611fd92532e)
  - Line 158: Export output dataframe to CSV file

### Order of the Mass and Spectrophotometer Data
R reads in the spectrophotometer triplicate data starting in line 37 in the following order: 

![Image](https://github.com/user-attachments/assets/1b74973a-12b3-4b57-bad4-a7e5a9b30ece)

The mass data excel files need to be in order from sample #1-24, where samples #1-12 are from the spectrophotometer data C1:E12, and samples #13-24 are from F1:H12. 

## License
You can freely use and modify the code, without warranty, so long as you provide attribution to the authors.

The manuscript text is not open source. The authors reserve the rights to the article content, which is being submitted for publication in PNAS.
