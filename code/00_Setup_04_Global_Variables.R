################################################################################
# Name of file:       00_Setup_04_Global_Variables.R
# Type of script:     R
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Define global variables
################################################################################

### 00 Get some generic info about the user/system ----

run_details <- get_details()

### 01 Decide on the number of cores to use ----

num_cores <- min(4, run_details$max_cores)
print(paste("This session will use", num_cores, "of", run_details$max_cores, "cores."))

### 02 Amend output path

# Advise the user that they will be asked to select a directory suitable for
# writing data to i.e. a sub-directory of /conf
rstudioapi::showDialog(title = "Notice",
  message = paste(
    "This script writes data extracted from the SMRA database to disk.",
    "You will be prompted to select a sub-directory of '/conf' to write these",
    "data to."))

# Ask the user to select the directory to write data to
output_path <- file.path(rstudioapi::selectDirectory(
  caption = "Select directory to write data to...",
  label = "Select",
  path = file.path("/conf")))

# Check if the value of output_path is empty; if it is, end the session
if(rlang::is_empty(output_path)){
  rstudioapi::showDialog(title = "Notice",
    message = paste("You did not select a directory to write data to.",
                    "This RStudio Workbench session will now close."))
  quit(save = "no")
}

if(!dir.exists(output_path)){dir.create(output_path, recursive = TRUE)} # create output folder if needed
