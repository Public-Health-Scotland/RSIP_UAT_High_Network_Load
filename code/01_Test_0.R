#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Name of file:       01_Test_0.R
# Type of script:     R
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
# 
# Test 0
# ------
# Benchmark extracting data from the SMRA database, writing these data to Stats
# then reading them back into R again.
#
# Focus on small extracts of data, run repeatedly in quick succession to really
# test network stability.
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### -- Benchmarking ----

## Define function to perform extract, write and read activities
benchmark_fetch_and_write <- function(x, i){
  # Define an SQL query to return x rows from the SMR01 dataset
  sql <- paste0("SELECT * FROM ANALYSIS.SMR01 WHERE ROWNUM <= ", x)
  
  # Fetch Data
  message(paste0("Fetching ", x, " rows from SMR01 ", i, " times"))
  {
    gc() # Garbage Collection
    start_time <- Sys.time()
    bm1 <- bench::mark(
      fetch_data = {
        # Submit the SQL query
        rs <- DBI::dbSendQuery(SMRA_connection, sql)
        
        # Fetch the results
        data <- DBI::dbFetch(rs)
        
        # Clear the resultset
        DBI::dbClearResult(rs)
        rm(rs)
        gc()
      },
      iterations = i,
      check = FALSE
    )
    stop_time <- Sys.time()
  }
  
  output1 <- as.data.frame(run_details) |> 
    tibble::as_tibble() |>
    dplyr::mutate(activity = "Fetch Data from SMRA",
                  n_rows = x,
                  start_time = start_time,
                  stop_time = stop_time) |>
    dplyr::bind_cols(bm1 |> dplyr::select(min, median, `itr/sec`, mem_alloc, `gc/sec`, n_itr, n_gc, total_time))
  
  # Write Data
  message(paste0("Writing data frame with ",
                 ncol(data), " columns and ", nrow(data), " rows to disk ",
                 i, " times"))
  write_data_path <- file.path(output_path, paste0("01_Test_0 Data ", x, " rows ", stringr::str_replace_all(Sys.time(), ":", ""), ".csv"))
  {
    gc()
    start_time <- Sys.time()
    bm2 <- bench::mark(
      write_data = {
        readr::write_excel_csv(data, file = write_data_path)
      },
      iterations = i,
      check = FALSE
    )
    stop_time <- Sys.time()
  }
  
  output2 <- as.data.frame(run_details) |> 
    tibble::as_tibble() |>
    dplyr::mutate(activity = "Write Data to Stats",
                  n_rows = x,
                  start_time = start_time,
                  stop_time = stop_time) |>
    dplyr::bind_cols(bm2 |> dplyr::select(min, median, `itr/sec`, mem_alloc, `gc/sec`, n_itr, n_gc, total_time))
  
  # Read Data
  message(paste0("Reading CSV with ",
                 ncol(data), " columns and ", nrow(data), " rows from disk ",
                 i, " times"))
  {
    gc()
    start_time <- Sys.time()
    bm3 <- bench::mark(
      read_data = {
        suppressMessages(readr::read_csv(data, file = write_data_path))
      },
      iterations = i,
      check = FALSE
    )
    stop_time <- Sys.time()
    }
  
  output3 <- as.data.frame(run_details) |> 
    tibble::as_tibble() |>
    dplyr::mutate(activity = "Read Data from Stats",
                  n_rows = x,
                  start_time = start_time,
                  stop_time = stop_time) |>
    dplyr::bind_cols(bm3 |> dplyr::select(min, median, `itr/sec`, mem_alloc, `gc/sec`, n_itr, n_gc, total_time))
  
  # Erase data written to Stats
  file.remove(write_data_path)
  
  # Bind results into a single data frame and return from function
  
  output <- dplyr::bind_rows(output1, output2, output3)
  
  return(output)
}

## Define the size of extracts to test, and how many times to test each size of
## extract
n_rows <- c(1, 10, 100, 1000, 5000, 10000)
n_itr <- rep(100, length(n_rows))

## Run the tests and collect the benchmarking results
results <- purrr::map2_dfr(n_rows, n_itr, benchmark_fetch_and_write)

### -- Write benchmarking results to file ----

results_file <- file.path(output_path, paste0("01_Test_0 Results ", stringr::str_replace_all(Sys.time(), ":", ""), ".csv"))
readr::write_csv(results, file = results_file, append = file.exists(results_file))

### -- Thank user and close session ----

DBI::dbDisconnect(SMRA_connection)
print("This test has completed. The RStudio Workbench session will now close.")
quit(save = "no")
