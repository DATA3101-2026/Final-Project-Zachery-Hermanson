# ----- [Libraries (Used / Unused)] -----
library(dplyr)
library(ggplot2)
#library(tidyverse)
#library(httr2)
#library(rinat)
#library(RJSONIO)
#library(sf)
#library(cowplot) 
#library(maps)
#library(lubridate)
#library(jsonlite)

# ----- [Downloading Data set] -----

# --- [Folder Check] ---
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/clean", recursive = TRUE, showWarnings = FALSE)

# --- [Data Download] ---


# Checks if the zip file exists, if it doesn't then it downloads it
if (!file.exists("data/raw/openpowerlifting-latest.zip")) {download.file(url = "https://openpowerlifting.gitlab.io/opl-csv/files/openpowerlifting-latest.zip", destfile = "data/raw/openpowerlifting-latest.zip", mode = "wb")}

# Unzips the downloaded folder
unzip(zipfile = "data/raw/openpowerlifting-latest.zip", exdir = "data/raw/")

# Because openpowerlifting updates often, the extracted .csv file needs to be renamed.
# Data below taken from https://stackoverflow.com/questions/74713794/what-is-the-meaning-of-recursive-and-full-names-in-the-list-files-function
extract <- list.files(path = "data/raw", pattern = "^openpowerlifting.*\\.csv$", recursive = TRUE, full.names = TRUE)

# Data below taken from https://stackoverflow.com/questions/74713794/what-is-the-meaning-of-recursive-and-full-names-in-the-list-files-function

# Automatically renames the .csv file if the length of the name is over 0.
# File manipulation can be found here: https://stat.ethz.ch/R-manual/R-devel/library/base/html/files.html, got the idea of using length() from my Intro Comp Sci class.
if (length(extract) > 0 && !file.exists("data/raw/openpowerlifting.csv")) {file.rename(from = extract[1], to = "data/raw/openpowerlifting.csv")}


# ----- [Setting up data set] -----

openlift <- read.csv("data/raw/openpowerlifting.csv", stringsAsFactors = TRUE)

# ----- [Data Cleaning] -----

# --- [Separating needed columns from unneeded columns] ---

# Listing the columns I want to be seperated so I can focus on this data specifically.
Needed <- c("Sex","Event","Equipment","Age","BodyweightKg","Squat1Kg", "Squat2Kg", "Squat3Kg", "Best3SquatKg","Bench1Kg", "Bench2Kg", "Bench3Kg", "Best3BenchKg","Deadlift1Kg", "Deadlift2Kg", "Deadlift3Kg", "Best3DeadliftKg","TotalKg","Dots", "Wilks","Date","Tested","Country","State")

# Storing the trimmed version as a new data frame.
openlifttrim <- openlift %>% select(any_of(Needed))

# Ensuring all dates are in the same format. (precaution)
openlifttrim$Date <- as.Date(openlifttrim$Date)

# Convert fake made up units (Kg) to actual people units (Lbs)
openlifttrim <- openlifttrim %>% mutate(across(ends_with("Kg"), ~ .x * 2.20462)) %>% rename_with (~sub("Kg$", "Lbs", .x), ends_with( "Kg"))

# Eliminates all untested lifters 
openlifttrim <- openlifttrim %>% filter(Tested == "Yes")

# ----- [Part 3 Requirements] -----

# --- [Writing the clean .csv] ---
write.csv(openlifttrim, "data/clean/openpowerliftingclean.csv", row.names = FALSE)

# --- [Graph Creation] ---
opencountry <- openlifttrim %>% filter(!is.na(Country), Country != '', !is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(TotalLbs), TotalLbs > 0)

# Creates a segregated and refined data set, set up work for graphing.
strongestcountries <- opencountry %>% filter(Event =="SBD", !is.na(Dots), Dots > 0) %>% group_by(Country) %>%
  summarise(lifternumbers = n (),
            dotsaverage = mean(Dots),
            .grups = "drop") %>% filter(lifternumbers >= 100) %>% slice_max(dotsaverage, n = 10)
                                                                                                  

ggplot(strongestcountries, aes(x = reorder(Country, dotsaverage), y = dotsaverage)) +
  geom_col(fill = "red") +
  coord_flip() +
  labs(title = "Strongest Countries in Powerlifting",
       x = NULL,
       y = "Average Dots Score"
       ) 

# ----- [Data Analysis / DON'T RUN PAST THIS POINT] -----

# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $                                                                            $
# $   SSSSS  TTTTTTT  OOOOO  PPPPPP   !!   DO NOT RUN PAST THIS POINT          $
# $  S          T    O     O P     P  !!                                       $
# $   SSSSS     T    O     O PPPPPP   !!   Everything below is past part 3     $
# $        S    T    O     O P        !!   Everything below this sign is for   $
# $   SSSSS     T     OOOOO  P        !!   the next part                       $
# $                                                                            $
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

stop("Stopped intentionally, no need to run the code past the warning as everything past is a set up for part 4")

# Creates a data frame for the trinity events.
opentrinity <- openlifttrim %>% filter( Event == "SBD", !is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(TotalLbs), TotalLbs > 0)

# Creates a date frames for individual lifters strength to body weight
openbench <- openlifttrim %>% filter(!is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(Best3BenchLbs), Best3BenchLbs >0)
opensquat <- openlifttrim %>% filter(!is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(Best3SquatLbs), Best3SquatLbs >0)
opendead <- openlifttrim %>% filter(!is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(Best3DeadliftLbs), Best3DeadliftLbs >0)

# Creates a data frame for Country and State comparisons
opencountry <- openlifttrim %>% filter(!is.na(Country), Country != '', !is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(TotalLbs), TotalLbs > 0)
openstate <- openlifttrim %>% filter(!is.na(State), Country != '', !is.na(BodyweightLbs), BodyweightLbs > 0, !is.na(TotalLbs), TotalLbs > 0)

# ----- [Checking Data / Events] -----

# This code is for checking, doesn't need to be run.

colSums(is.na(openlifttrim[, c("BodyweightKg", "TotalKg", "Dots", "Wilks", "Country")]))
table(openlifttrim$Event, useNA = "ifany")
sum(openlifttrim$Country == "", na.rm = TRUE)
# ----- [Descriptions] -----

# Sex             - Competitive gender category
# Equipment       - Supportive gear (i.e. Wraps, straps)
# Age             - Lifters Exact age at time of competing (may have .5 if birthyear is unknown)
# AgeClass        - Competitive Age Bracket
# BirthYearClass  - Age bracket by birth year
# BodyweightKG    - Body weight in made up units (Kg :(, convert this trash))
# SquatXKg        - Weighted attempts per 1st, 2nd, 3rd, 4th attempt (4th will be removed since its not related to TotalKg)
# Best3SquatKG    - Heaviest squat among first three attempts
# BenchXKg        - Same rules as Squat
# Best3BenchKG    - Same rules as Best3SquatKg
# DeadliftxKg     - Same rules as Squat
# Best3DeadliftKg - Same rules as Best3SquatKg
# TotalKg         - Sum of Best3SquatKg, Best3BenchKg, and Best3DeadliftKg
# Country         - Lifter's home country
# State           - Lifter's home state, province, or region
# Date            - Date of Competition

# ----- [Event Translation] -----

# B     - Bench event
# BD    - Bench / Dead lift event
# D     - Deadlift event
# S     - Squat event
# SB    - Squat / Bench event
# SBD   - Trinity event
# SD    - Squat / Dead lift event