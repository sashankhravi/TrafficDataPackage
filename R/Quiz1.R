#'fars_read
#'
#'This function reads the data in the file specified by the file name, without the messages.
#'If the file does not exist, then the function stops the execution and returns an error
#'
#'@param filename The name of the file, whose data is to be extracted
#'
#'@importFrom dplyr tbl_df
#'
#'@return This function returns a data frame having data from the file
#'
#'@examples
#'\dontrun{data1 <- fars_read('accident_2013.csv')}
#'
#'@export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#'make_filename
#'
#'Since there is data available for each year, this function takes the input year and then prints the
#'filename corresponding to that year, and also makes the filename for that year.
#'
#'@param year The input year
#'
#'@return This function prints the filename corresponding to the year requested
#'
#'@examples
#'\dontrun{make_filename(2013)}
#'
#'@export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv", year)
}

#'fars_read_years
#'
#'This function takes all the years, and for each year, it obtains the filename for that year, then
#'reads that file, adds the year data, and then selects the months and year columns
#'
#'@param years The years input for all years for which files are available
#'
#'@importFrom dplyr mutate
#'@importFrom dplyr select
#'
#'@return The month and year from the file
#'
#'@examples
#'\dontrun{fars_read_years(c(2013, 2014))}
#'
#'@export
fars_read_years <- function(years) {
        MONTH <- NULL
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dat2<- dplyr::mutate(dat, year = year)
                               dplyr::select(dat2, MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#'fars_summarize_years
#'
#'This function takes the year and month out of the data, and obtains the number of observations in
#'each month of each year
#'
#'@inheritParams fars_read_years
#'
#'@importFrom dplyr bind_rows
#'@importFrom dplyr group_by
#'@importFrom dplyr summarize
#'@importFrom tidyr spread
#'@importFrom dplyr n
#'
#'@return The summarized data having number of entries for each month in each year
#'
#'@examples
#'\dontrun{fars_summarize_years(c(2013, 2014))}
#'
#'@export
fars_summarize_years <- function(years) {
        year <- NULL
        MONTH <- NULL
        n <- NULL
        dat_list <- fars_read_years(years)
        dat_list2<- dplyr::bind_rows(dat_list)
        dat_list3<- dplyr::group_by(dat_list2, year, MONTH)
        dat_list4<- dplyr::summarize(dat_list3, n = n())
        tidyr::spread(dat_list4, year, n)
}

#'fars_map_state
#'
#'This function takes a state number and year as the input, and then it takes the state name
#'corresponding to the state number. Then for all data points with NA, it ensures that no values
#'with NA are present. Finally, it makes a map of the latitudes and longitudes for that state.
#'Also, the function has error checks to ensure that the state number is valid, and also returns
#'NULL if there are no accidents in that state in that year
#'
#'@param state.num A number indicating the state
#'
#'@inheritParams make_filename
#'
#'@importFrom dplyr filter
#'
#'@return A plot showing the latitude and longitude points where the accident happened
#'
#'@examples
#'\dontrun{fars_map_state(10, 2013)}
#'
#'@export
fars_map_state <- function(state.num, year) {
        STATE <- NULL
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
