# TrafficDataPackage
This package is a test assignment in the R-Programming course on Coursera. In this package, the data which contains the number of vehicular
accidents occured in the United States in three successive years is taken, and then certain operations are performed on the data like
summarizing the number of observations of each month in each year, and obtaining the plot of all accidents in a particuler state for
a particular calendar year, 

# Sample Preview
```{r}
fars_summarize_years(c(2013, 2014))
```
would display the number of accidents for each month in each year for 2013 and 2014. 

# Motivation
This package gives a very good practice for creating packages in R, and uploading these packages through GitHub, and verifying with Travis

#Badge Image
[![Build Status](https://travis-ci.org/sashankhravi/TrafficDataPackage.svg?branch=master)](https://travis-ci.org/sashankhravi/TrafficDataPackage)
