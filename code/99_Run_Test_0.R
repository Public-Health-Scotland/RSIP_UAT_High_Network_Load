#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Name of file:       99_Run_Test_0.R
# Type of script:     R
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### -- Source R scripts ----

# Load the required packages from the 'renv' library
source("code/00_Setup_00_Packages.R")

# Now that the 'here' package is available, use this to point to the remaining
# R scripts to be sourced
code_path <- paste(here::here(), "code/", sep = "/")

# Set R, knitr and project-specific options
source(paste0(code_path, "00_Setup_01_Options.R"))

# Define file paths
source(paste0(code_path, "00_Setup_02_Paths.R"))

# Define functions
source(paste0(code_path, "00_Setup_03_Functions.R"))

# Define global variables
source(paste0(code_path, "00_Setup_04_Global_Variables.R"))

# Connect to SMRA database
source(paste0(code_path, "00_Setup_05_SMRA_Connection.R"))

### -- Run Test 0 ----
source(paste0(code_path, "01_Test_0.R"))
