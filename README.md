# google_capstone
My Google Data Analyst capstone project

This repository houses files I produced as part of my Google Data Analytics Capstone.

I chose one of the business cases presented: the bike ride sharing program.

I used data provided by the capstone instructions.

These data are .csv files that containt monthly ride sharing information.

# DATA CLEANING

I cleaned these data in Microsoft Excel:
adding two summary columns of data for "weekday" (=WEEKDAY, 1) and "ride_dur_min" (calculated value from the difference between the date/time the ride ended and the date/time the ride initiated. 

I also omitted rows where the "ride_dur_min" calculated value was less than zero. I did this using the filters in Excel.

Once each month of data was cleaned, I saved each one as an Excel file (.xlsx).

# ANALYSIS

I used R to summarize the mean number of rides per day and the average ride duration per day for riders with annual memberships (member) and casual riders (casual).

Included in this repository is my summary of these data as a .csv file

I also present my R script as a demonstration of my process and decisions I took along the way. Some of the code is taken from the capstone instructions, and some is the product of googling.

# CONCLUSION

I still need to formally write-up my results. I am thinking a powerpoint presentation, similar to what I would present to my stakeholders.
