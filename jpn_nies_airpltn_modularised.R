library(dplyr)
library(archive)

# Set locale
Sys.setlocale("LC_CTYPE", "Japanese")

# Paths
root_path <- "D:/JPN-AirPollution/jpn_airpollution_rawdata09-22"
output_dir <- file.path(root_path, "unzipped_data")
dir.create(output_dir, showWarnings = FALSE)

# ---- Function to unzip top-level yearly files ----
unzip_year_files <- function(zip_files, output_dir) {
        for (zip_file in zip_files) {
                subfolder <- file.path(output_dir, tools::file_path_sans_ext(basename(zip_file)))
                dir.create(subfolder, showWarnings = FALSE)
                unzip(zip_file, exdir = subfolder)
        }
}

# ---- Function to extract prefecture-level ZIPs using archive package ----
extract_prefecture_zips <- function(year_folders) {
        for (year_folder in year_folders) {
                prefecture_zips <- list.files(path = year_folder, pattern = "\\.zip$", full.names = TRUE)
                
                for (zip_file in prefecture_zips) {
                        subfolder <- file.path(year_folder, tools::file_path_sans_ext(basename(zip_file)))
                        dir.create(subfolder, showWarnings = FALSE)
                        archive::archive_extract(zip_file, dir = subfolder)
                }
        }
}

# ---- Function to read and clean a single file ----
read_data_file <- function(file) {
        prefecture_folder <- basename(dirname(dirname(file)))
        prefecture <- sub("^[0-9]+_", "", prefecture_folder)
        
        df <- tryCatch({
                read.table(file, header = TRUE, sep = ",", fileEncoding = "cp932")
        }, error = function(e) {
                message("Failed to read: ", file)
                return(NULL)
        })
        
        if (!is.null(df) && ncol(df) >= 30) {  # crude check
                df$prefecture <- prefecture
                return(df)
        } else {
                message("Skipped malformed file: ", file)
                return(NULL)
        }
}

# ---- Function to process all years ----
process_all_years <- function(years, base_path) {
        data_list <- list()
        
        for (yr in years) {
                message("Processing year: ", yr)
                year_path <- file.path(base_path, paste0("j00_", yr))
                file_list <- list.files(path = year_path, pattern = "\\.txt$", full.names = TRUE, recursive = TRUE)
                
                year_data <- bind_rows(lapply(file_list, read_data_file))
                
                if (ncol(year_data) >= 30) {
                        colnames(year_data)[1:29] <- c(
                                "year", "station_code", "municipality_code", "measurement_code",
                                "unit_code", "month", "day", paste0("X", sprintf("%02d", 1:24), "h")
                        )
                        # Ensure last column is 'prefecture'
                        colnames(year_data)[ncol(year_data)] <- "prefecture"
                }
                
                data_list[[as.character(yr)]] <- year_data
        }
        
        return(data_list)
}



# ---- Run steps ----
# Step 1: Unzip year-level archives
zip_files <- list.files(path = root_path, pattern = "\\.zip$", full.names = TRUE)
unzip_year_files(zip_files, output_dir)

# Step 2: Extract nested prefecture-level ZIPs
year_folders <- list.dirs(output_dir, full.names = TRUE, recursive = FALSE)
extract_prefecture_zips(year_folders)

# Step 3: Process data into a combined list
years <- 2009:2022
data_list <- process_all_years(years, output_dir)

# Step 4: Save output
save(data_list, file = "jpn_air_poltn_nies.RData")
