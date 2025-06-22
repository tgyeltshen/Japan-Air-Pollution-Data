# Japan-Air-Pollution-Data
I understand that many international researchers in Japan faces troubles with the acess to air pollution data due to Mojibake eventhough the data is made public available by the NIES. 
Japan’s national air pollution data, released by NIES, is structured in deeply nested .zip archives with Japanese-encoded folder names. This repo contains walk-through to the full R workflow to:

1. Extract yearly ZIPs

2. Extract nested prefecture-level ZIPs

3. Read all .txt files inside

Clean and combine them into a single R object for analysis. 

## Step 1 Download the raw files from the NIES website:
https://tenbou.nies.go.jp/download/
Depending on your use case - download the appropriate data combinations. NIES provides monthly and annual data, Time Value data which is hournly for 24 hours by prefectures and national level; and also measurement station specific data. For this repo, I have downloaded the Time Value Data by prefectures for the years 2009 - 2022.

Hence all the codes shareed in this repo is for the **Time Value Data given hourly for 24 hours by prefecture**

## Step 2 Run the R scripts 

Run Step 1 unzips year-level archives 
Run step 2 extracts nested prefectur-level zips

#### Step 2a
Run Step 3 processes data into a combined list. 


## Step 2a Using windows Powershell to automatically map the names. 
Once you have downloaded environmental datasets from the NIES, Japan; unzip it to the folder "unzipped_data". When you unzip it, you will get unzipped folders with folder names patterns j00_2009 - j00_2022. 
In each of these subfolders are the  folders; one each for each prefecture with file name pattern j01_2009 - j47_2009. Within these foloders is a nested zip file for each prefecture with prefecture names which are writtein in Japanese character "KANJI". see the tree example below: 

D:\JPN-AirPollution\
└── jpn_airpollution_rawdata09-22\
    └── unzipped_data\
        └── j00_2009\
            └── j01_2009\
                └── 01北海道\
                    └── 2009\


Extracting this file will give you garbled character name for the folder because of encoding issues. To avoid this mojibake, we use Windows powershell to rename the prefecture names to English with correct ASCII encoding. use .ps1 
Before running the Run Sep 3 in the script. Follow Step 2a. 

This step can be skipped if you use Japanese encoding system in your machine. 

These steps will give you processed air pollution data by prefecture hourly and can further be aggregated to daily time series.
