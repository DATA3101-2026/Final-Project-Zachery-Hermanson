# OpenPowerLifting Weight to Strength Correlation Audit
Zachery James Hermanson
2026-11-07

- [1: Project Overview](#1-project-overview)
- [2: Data Sources](#2-data-sources)
  - [2.1 Summary of sources](#21-summary-of-sources)
  - [2.2.1: Data Set Information & Fair
    Use](#221-data-set-information--fair-use)
  - [2.3: Investigated and rejected
    sources](#23-investigated-and-rejected-sources)
  - [2.4: What I could not find](#24-what-i-could-not-find)
- [3: Licensing and permissions](#3-licensing-and-permissions)
  - [3.1: Licence by source](#31-licence-by-source)
  - [3.3: Downstream permissions](#33-downstream-permissions)
- [4: Consent and identifiability](#4-consent-and-identifiability)
- [5: Exclusions and harms](#5-exclusions-and-harms)
  - [5.1: Excluded data from the
    audit](#51-excluded-data-from-the-audit)
  - [5.2: Who could be harmed](#52-who-could-be-harmed)
  - [5.3: Unreleased working data](#53-unreleased-working-data)
- [6: Data Stewardship](#6-data-stewardship)
- [7: Use of AI](#7-use-of-ai)
- [8: Session information](#8-session-information)

<!--  another version of markdown elements, this works for html-style documents
&#10;[FP Part 2: HOW TO USE THIS TEMPLATE FOR YOUR SUBMISSION
&#10;Replace every bracketed prompt with your own writing (remove the brackets themselves, they're part of the placeholder here), and delete the prompt. 
&#10;Delete any sections that are not relevant for project, but note in commit message notes (not commit titles!) why you chose to delete them. That way I know that you've been thinking through what will be relevant as you begin the coding portion of this project.
&#10;Render, commit and push the markdown AND the .Rmd to your final project folder. 
&#10;This document will live in your final project folder in your repository alongside the AI-LOG.md, your code, and your raw data. Remember to commit it as you work on it, so that it doesn't get mixed up in your class or assignment commit messages.]
-->

# 1: Project Overview

This project acts as window into the relationship between a
powerlifter’s bodyweight and their overall strength. Will a
powerlifter’s bodyweight be directly correlated with compound lifts
(squat + deadlift + benchpress)? This project will focus on cleaning the
data set, seperating genders, identifying age classes, weight classes,
and graphing the information to see strength standard trends.

------------------------------------------------------------------------

# 2: Data Sources

## 2.1 Summary of sources

| Source | Producer | Format | Coverage | Using |
|:---|:---|:---|:---|:---|
| OpenPowerLifting.org | OpenPowerLifting | CSV | Global,- 1964 - Present | Yes |
| Data Acquisition & Organization | Mount Allison University / Catherine Evans | Lecture | Mount Allison, 2026 | Yes |

## 2.2.1: Data Set Information & Fair Use

**Producer and authority.** OpenPowerLifing.org hosts an open-source,
non-profit collection of power lifting data. It is published as an open
data-set to standardize global power lifting meet results into a single
easy-to-use domain.

**Original Dataset Purpose.** The purpose of OpenPowerLifting.org is to
preserve power lifting data taken from professional meets and to provide
a comprehensive archive of athletic accomplishments. It is primarily
utilized to track rankings and analyze sport trends among athletes.

**Collection method.** The values are gathered manually through official
power lifting organizations using power lifting federation score sheets
and score-reporting platforms. The data provided is analyzed and
structured into a CSV file.

**Coverage and resolution.** This data set is globally covered through
multiple officially licenced power lifting federations. This data dates
as far back as 1964 to today through continuous competition results.

**Licence.** Creative Commons Zero (CC0 1.0 Universal) Public Domain
Dedication, allowing unrestricted use, modification, and distribution
for any purpose.

**Access.** Downloaded directly from OpenPowerLifting.org public git.
Accessed through OpenPowerLifting.org/data.

**Known problems.** After a brief look through, some values are missing.
Some figures that are required for my project appear to have a null
value such as Best3SquatKg, Bench, and Deadlift. Some body weight is
also missing.

``` r
raw_1 <- read_csv("C:/Users/zache/OneDrive/Documents/GitHubRepos/Final-Project/data/raw/openpowerlifting-2026-10-17-c7782562.csv") # example for a csv file
```

    Rows: 4050248 Columns: 42
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr  (19): Name, Sex, Event, Equipment, AgeClass, BirthYearClass, Division, ...
    dbl  (22): Age, BodyweightKg, Squat1Kg, Squat2Kg, Squat3Kg, Squat4Kg, Best3S...
    date  (1): Date

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
glimpse(raw_1) |> select(1:6) 
```

    Rows: 4,050,248
    Columns: 42
    $ Name             <chr> "E.S. Denisenko", "I.S. Lebetskaya", "K. Yakimovich",…
    $ Sex              <chr> "F", "F", "F", "F", "F", "M", "M", "M", "M", "M", "M"…
    $ Event            <chr> "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"…
    $ Equipment        <chr> "Raw", "Raw", "Raw", "Raw", "Raw", "Raw", "Raw", "Raw…
    $ Age              <dbl> 28.5, 43.5, 26.5, 19.5, 19.5, 30.5, 40.5, 21.5, 23.5,…
    $ AgeClass         <chr> "24-34", "40-44", "24-34", "20-23", "20-23", "24-34",…
    $ BirthYearClass   <chr> "24-39", "40-49", "24-39", "19-23", "19-23", "24-39",…
    $ Division         <chr> "Open", "Open", "Open", "Juniors 17-21", "Juniors 17-…
    $ BodyweightKg     <dbl> 67.3, 73.2, 60.6, 50.3, 63.7, 82.0, 79.3, 80.1, 88.0,…
    $ WeightClassKg    <chr> NA, NA, NA, NA, NA, "82.5", "82.5", "82.5", "90", "90…
    $ Squat1Kg         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Squat2Kg         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Squat3Kg         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Squat4Kg         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Best3SquatKg     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Bench1Kg         <dbl> -40.0, 80.0, 40.0, 32.5, 40.0, 127.5, 150.0, 87.5, 16…
    $ Bench2Kg         <dbl> -45.0, 85.0, 42.5, 35.0, 42.5, 132.5, 160.0, 95.0, 17…
    $ Bench3Kg         <dbl> -45.0, 90.0, 45.0, -37.5, -45.0, NA, -167.5, -97.5, 1…
    $ Bench4Kg         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Best3BenchKg     <dbl> NA, 90.0, 45.0, 35.0, 42.5, 132.5, 160.0, 95.0, 177.5…
    $ Deadlift1Kg      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Deadlift2Kg      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Deadlift3Kg      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Deadlift4Kg      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Best3DeadliftKg  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ TotalKg          <dbl> NA, 90.0, 45.0, 35.0, 42.5, 132.5, 160.0, 95.0, 177.5…
    $ Place            <chr> "DQ", "1", "2", "2", "1", "2", "1", "3", "1", "3", "D…
    $ Dots             <dbl> NA, 88.80, 49.57, 43.67, 45.40, 90.07, 110.90, 65.46,…
    $ Wilks            <dbl> NA, 86.89, 49.79, 44.76, 45.26, 89.09, 109.84, 64.81,…
    $ Glossbrenner     <dbl> NA, 76.50, 43.98, 39.73, 39.96, 85.74, 105.88, 62.44,…
    $ Goodlift         <dbl> NA, 70.06, 38.42, 34.55, 35.25, 66.97, 82.28, 48.60, …
    $ Tested           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Country          <chr> "Belarus", "Belarus", "Belarus", "Belarus", "Belarus"…
    $ State            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Federation       <chr> "GSF-Belarus", "GSF-Belarus", "GSF-Belarus", "GSF-Bel…
    $ ParentFederation <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ Date             <date> 2019-06-22, 2019-06-22, 2019-06-22, 2019-06-22, 2019…
    $ MeetCountry      <chr> "Belarus", "Belarus", "Belarus", "Belarus", "Belarus"…
    $ MeetState        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ MeetTown         <chr> "Luninets", "Luninets", "Luninets", "Luninets", "Luni…
    $ MeetName         <chr> "Bison Power Cup", "Bison Power Cup", "Bison Power Cu…
    $ Sanctioned       <chr> "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes", "Yes…

    # A tibble: 4,050,248 × 6
       Name              Sex   Event Equipment   Age AgeClass
       <chr>             <chr> <chr> <chr>     <dbl> <chr>   
     1 E.S. Denisenko    F     B     Raw        28.5 24-34   
     2 I.S. Lebetskaya   F     B     Raw        43.5 40-44   
     3 K. Yakimovich     F     B     Raw        26.5 24-34   
     4 A.G. Golneva      F     B     Raw        19.5 20-23   
     5 E.V. Marunevskaya F     B     Raw        19.5 20-23   
     6 D. Gimbitskiy     M     B     Raw        30.5 24-34   
     7 S. Kozlov         M     B     Raw        40.5 40-44   
     8 V.O. Shevchenko   M     B     Raw        21.5 20-23   
     9 M.S. Drozdov      M     B     Raw        23.5 24-34   
    10 Yu.G. Rimsha      M     B     Raw        35.5 35-39   
    # ℹ 4,050,238 more rows

This data set displays information about the athletes like their names,
sex, and the event. It also displays aspects of their lifts like
equipment age, age class, and division type plus their strength
standards on compound lifts.

## 2.3: Investigated and rejected sources

I did not find any sources to deny / reject at the time of writing this
code on November 7, 2026.

If a future source is rejected I will put the reason here \<—

## 2.4: What I could not find

I found all the information I needed for me to complete my project, all
neatly organized in one csv file. Lucky me.

------------------------------------------------------------------------

# 3: Licensing and permissions

## 3.1: Licence by source

| Source | Licence | Attribution_required | Attribution_given |
|:---|:---|:---|:---|
| OpenPowerLifting.org | CC0 1,0 Universal | No | No |

**Attribution statements.**

- OpenPowerlifting: Because the OpenPowerlifting dataset is released
  under a CC0 1.0 Universal (Public Domain Dedication), no specific
  formal attribution wording is legally required by the license.
  However, academic best practice is to credit the data source as: “Data
  courtesy of OpenPowerlifting (openpowerlifting.org).

## 3.3: Downstream permissions

The data set used is open-source through CC0. This final project output
is fully open. Anyone is free to view, reuse, modify, distribute, or
build upon this data project and its code without licences.

------------------------------------------------------------------------

# 4: Consent and identifiability

**Consent.** This data provides the users with individual human
powerlifter’s details such as names, sex, and age. The data is sourced
from open athletic competition results that are public records. In order
for these athletes to compete they must meet under federation rules that
record key identifiers such as names, weights, performance statistics,
and doping tests. For the purpose of this project names will not be used
in any graph or collective.

**Identifiability.** This data set is publicly recorded through athlete
sport statistics and utilizes information like competition names, body
weights, and strength numbers through power lifting competitions.
Because these records are shared publicly, individual identification is
based entirely on publicly available results from competitions. However,
for this project names will not be used, but key characteristics of
athletes will be analysed

**How sensitive data will be used.** Although the OpenPowerLifting data
set has names and competition data this project will be analyzing
strength standards on a population level rather than an individual
level. Names and specific athletes will **not** be singled out. all
information found in this project will be used in figures such as
summary tables, regression models, and graphs. This will ensure that no
individual identity is highlighted.

------------------------------------------------------------------------

# 5: Exclusions and harms

## 5.1: Excluded data from the audit

Every published dataset will demonstrate what an author aimed to
prioritize, and lack of data or missing data can show the same. If you
removed a column of the unprocessed dataset, describe what it was, and
why you decided to remove it. That could be things like sensitive
variables, time periods, places, categories. How could this exclusion
affect your data points in your analysis? **Once I start analyzing this
data more I will look into data removal**

## 5.2: Who could be harmed

Misuse of this data would include external companies that might affect
individuals found in these competitions. Companies that revolve around
insurance or employment. Misusing this data could result in false
conclusions regarding physical wellness, workplace compatibility, or
insurance rate adjustments.

## 5.3: Unreleased working data

Due to this data set being public through CC0. It is entirely safe to
publish my project. This project will be almost exclusively relying on
Bodyweightkg, and Totalkg. There is no unreleased working data in this
project that needs to be withheld.

------------------------------------------------------------------------

# 6: Data Stewardship

**Where it lives.** This project is hosted in a GitHub repository called
“Final-Project-Zachery-Hermanson” which can be found in “DATA3101-2026”

**Who maintains it.** I (Zachery Hermanson) will be maintaning this data
set until January 1st of 2027.

**Formats and dependencies.** The csv data may be updated and format
changed. As long as script files don’t evolve or get replaced, this code
should remain readable. Potential breakage could result from package
updates and incompatibilities.

**Lifespan.** As a consistently updated data set, this should not be
considered up to date unless the csv is consistently updated.

------------------------------------------------------------------------

# 7: Use of AI

**As of November 7, 2026 I have no plans to use AI, this may change and
if it does I will update this section.**

My `AI-LOG.md` will live in this repository and is committed alongside
my work it describes.

**AI log:** `AI-LOG.md` — November 7, 2026 and committed alongside each
stage of work.

Previously I would use AI for help during calorie counting and macro
dialing. Mostly for diet related purposes to help fine tune
caloric-deficits and caloric-surplus.

------------------------------------------------------------------------

# 8: Session information

``` r
# provides information about what was used within the markdown session, allowing reproducibility after publishing.
sessionInfo()
```

    R version 4.6.1 (2026-06-24 ucrt)
    Platform: x86_64-w64-mingw32/x64
    Running under: Windows 11 x64 (build 26300)

    Matrix products: default
      LAPACK version 3.12.1

    locale:
    [1] LC_COLLATE=English_Canada.utf8  LC_CTYPE=English_Canada.utf8   
    [3] LC_MONETARY=English_Canada.utf8 LC_NUMERIC=C                   
    [5] LC_TIME=English_Canada.utf8    

    time zone: America/Halifax
    tzcode source: internal

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
     [1] lubridate_1.9.5 forcats_1.0.1   stringr_1.6.0   dplyr_1.2.1    
     [5] purrr_1.2.2     readr_2.2.0     tidyr_1.3.2     tibble_3.3.1   
     [9] ggplot2_4.0.3   tidyverse_2.0.0

    loaded via a namespace (and not attached):
     [1] bit_4.6.0          gtable_0.3.6       jsonlite_2.0.0     crayon_1.5.3      
     [5] compiler_4.6.1     tidyselect_1.2.1   parallel_4.6.1     scales_1.4.0      
     [9] yaml_2.3.12        fastmap_1.2.0      R6_2.6.1           generics_0.1.4    
    [13] knitr_1.52         pillar_1.11.1      RColorBrewer_1.1-3 tzdb_0.5.0        
    [17] rlang_1.3.0        utf8_1.2.6         stringi_1.8.9      xfun_0.60         
    [21] S7_0.2.2           bit64_4.8.6        otel_0.2.0         timechange_0.4.0  
    [25] cli_3.6.6          withr_3.0.3        magrittr_2.0.5     digest_0.6.39     
    [29] grid_4.6.1         vroom_1.7.1        rstudioapi_0.19.0  hms_1.1.4         
    [33] lifecycle_1.0.5    vctrs_0.7.3        evaluate_1.0.5     glue_1.8.1        
    [37] farver_2.1.2       rmarkdown_2.32     tools_4.6.1        pkgconfig_2.0.3   
    [41] htmltools_0.5.9   
