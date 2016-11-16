library(TrafficDataPackage)
context("Given an input year, is the right filename coming out")

expect_equal(make_filename(2013), "accident_2013.csv")
expect_equal(make_filename(2025), "accident_2025.csv")
