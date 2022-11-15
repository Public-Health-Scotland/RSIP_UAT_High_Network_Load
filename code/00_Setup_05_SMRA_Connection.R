################################################################################
# Name of file:       00 Setup 05_SMRA_Connection.R
# Type of script:     R
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Define a connection to the SMRA database and functions that use this
# connection
################################################################################

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! SMRA CONNECTION  SMRA CONNECTION  SMRA CONNECTION  SMRA CONNECTION  SMRA CONN
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### Connect to SMRA database ----

dsn <- "SMRA"
uid <- run_details$user

tryCatch(
  {
    suppressWarnings(
      SMRA_connection <- odbc::dbConnect(
        drv = odbc::odbc(),
        dsn = dsn,
        uid = uid,
        pwd = rstudioapi::askForPassword("SMRA Password:"))
    )
  },
  error = function(err){
    message(err)
    rstudioapi::showQuestion(
      title = "Error",
      message = paste("Connection to the SMRA database was unsuccessful.",
                      "This RStudio Workbench session will now close.")
    )
    quit(save = "no")
  }
)

