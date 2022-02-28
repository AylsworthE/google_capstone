## Combine files for each of 12 months of data
## Data already cleaned in Excel

## Load Packages
library(tidyverse)
library(readxl)

## Read in files one at a time
## (there's probably a faster way to do this, but I can build later)

mon01 <- read_excel(path = "./files/202102_tripdata.xlsx")
mon02 <- read_xlsx(path = "./files/202103_tripdata.xlsx")
mon03 <- read_xlsx(path = "./files/202104_tripdata.xlsx")
mon04 <- read_xlsx(path = "./files/202105_tripdata.xlsx")
mon05 <- read_xlsx(path = "./files/202106_tripdata.xlsx")
mon06 <- read_xlsx(path = "./files/202107_tripdata.xlsx")
mon07 <- read_xlsx(path = "./files/202108_tripdata.xlsx")
mon08 <- read_xlsx(path = "./files/202109_tripdata.xlsx")
mon09 <- read_xlsx(path = "./files/202110_tripdata.xlsx")
mon10 <- read_xlsx(path = "./files/202111_tripdata.xlsx")
mon11 <- read_xlsx(path = "./files/202112_tripdata.xlsx")
mon12 <- read_xlsx(path = "./files/202201_tripdata.xlsx")

## Combine () months into one data frame
oneyear <- bind_rows(mon01, mon02, mon03, mon04, mon05, mon06, mon07, mon08, 
                     mon09, mon10, mon11, mon12)

## Remove unnecessary columns for Coursera/Cyclista analysis
## This makes it compatible with data from 2020 and on
oneyear <- oneyear %>%
        select(-(start_lat:end_lng))

## Follow the instructions given for the project
## Clean up and Add data to prepare for analysis

## Add columns for date only, year, month, and day
## Reference column is "started_at"
oneyear <- oneyear %>%
        mutate(date = as.Date(oneyear$started_at), 
               year = format(as.Date(oneyear$started_at), "%Y"), 
               month = format(as.Date(oneyear$started_at), "%m"), 
               day = format(as.Date(oneyear$started_at), "%d"),
               day_of_week = format(as.Date(oneyear$started_at), "%A"))

## Add a "ride_dur_sec" calculation to all_trips in seconds
oneyear <- oneyear %>%
        mutate(ride_dur_sec = difftime(oneyear$ended_at, oneyear$started_at))

## Check the structure of the columns, both imported and created with "mutate"
str(oneyear)

## Is "ride_dur_sec" a factor?
is.factor(oneyear$ride_dur_sec)

## Apparently, "ride_dur_sec" is a "difftime" class
class(oneyear$ride_dur_sec)

## Change this to a numeric class
oneyear$ride_dur_sec <- as.numeric(as.character(oneyear$ride_dur_sec))

## Check to make sure
class(oneyear$ride_dur_sec)

## Now, we will remove "bad" data
## We will remove quality checks, identified as "HQ QR" in "start_station_name
## and trips with durations < 0
## Remove these data points and create a new data frame: all2021_v2
oneyear_v2 <- oneyear[!(oneyear$start_station_name == "HQ QR" | 
                                oneyear$ride_dur_sec < 0), ]

## The number of "bad" data points
nrow(oneyear) - nrow(oneyear_v2)

## Now onto the next section of the R instructions for Cyclista project
## Conduct Descriptive Analysis

## Descriptive analysis on ride_length (all figures in seconds)

## Average duration of all rides in the dataset
mean(oneyear_v2$ride_dur_min, na.rm = TRUE)

## Median duration of all rides in the dataset
median(oneyear_v2$ride_dur_sec, na.rm = TRUE)

## Maximum duration of all rides in the dataset
max(oneyear_v2$ride_dur_sec, na.rm = TRUE)

## Minimum duration of all rides in the dataset
min(oneyear_v2$ride_dur_sec, na.rm = TRUE)

## What is up with the NAs???
## I cleaned data in Excel to omit any values less than zero for duration...
## Keep going.

## Do all four with summary()
summary(oneyear_v2$ride_dur_sec)

## There are NAs in the dataset, mostly associated with my member_casual column
## I hadn't focused on that at all, a good reminder to look at ALL data,
## not just the calculations

## Compare members and casual riders
oneyear_v2 %>%
        group_by(member_casual) %>%
        summarize(mean = mean(ride_dur_sec), median = median(ride_dur_sec),
                  max = max(ride_dur_sec), min = min(ride_dur_sec))

## See average ride duration for each day for members vs casual
oneyear_v2 %>%
        group_by(member_casual, day_of_week) %>%
        summarize(mean = mean(ride_dur_sec))

## The day_of_week variable is a character
## make it a factor with appropriate levels
oneyear_v2$day_of_week <- factor(oneyear_v2$day_of_week, 
                                 levels = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                            "Thursday", "Friday", "Saturday"))

## Let's see the average ride duration for each day for members vs causal again
oneyear_v2 %>%
        group_by(member_casual, day_of_week) %>%
        summarize(mean = mean(ride_dur_sec))

## What does this look like if we group by day first, then member_casual
oneyear_v2 %>%
        group_by(day_of_week, member_casual) %>%
        summarize(mean = mean(ride_dur_sec))

## Analyze ridership data by type and weekday
oneyear_v2 %>%
        group_by(member_casual, weekday) %>%
        summarize(number_of_rides = n(),
                  average_duration = mean(ride_dur_sec)) %>%
        arrange(member_casual, weekday)

## Let's visualize the number of rides by rider type
subset(oneyear_v2, !is.na(member_casual)) %>%
        group_by(member_casual, day_of_week) %>%
        summarize(number_of_rides = n(),
                  average_duration = mean(ride_dur_min, na.rm = TRUE)) %>%
        arrange(member_casual, day_of_week) %>%
        ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
        geom_col(position = "dodge") +
        scale_y_continuous(expand = expansion(mult = c(0, .1)),
                           labels = scales::comma) +
        scale_fill_manual(values = c("yellow2", "seagreen4")) +
        theme_classic() +
        labs(fill = "Membership",
             x = NULL,
             y = "Number of rides"
        )

## Let's visualize the average duration of rides by member type by day
subset(oneyear_v2, !is.na(member_casual)) %>%
        group_by(member_casual, day_of_week) %>%
        summarize(number_of_rides = n(),
                  average_duration = mean(ride_dur_min, na.rm = TRUE)) %>%
        arrange(member_casual, day_of_week) %>%
        ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
        geom_col(position = "dodge") +
        scale_y_continuous(expand = expansion(mult = c(0, .1))) +
        scale_fill_manual(values = c("yellow2", "seagreen4")) +
        theme_classic() +
        labs(fill = "Membership",
             x = NULL,
             y = "Average duration of rides (in minutes)"
        )

## Export a .csv file of summarized data
## Make a new dataset of summarized data, using minutes
counts <- subset(oneyear_v2, !is.na(member_casual)) %>% 
        group_by(member_casual, day_of_week) %>%
        summarize(average_ride_duration = mean(ride_dur_min))

write_csv(counts, file = "Mean_ride_duration.csv")