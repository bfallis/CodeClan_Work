library(purrr)
source("../response_unpacker.R")

complete <- list(results = list(anger = 0.1, fear = 0.2, joy = 0.3, 
        sadness = 0.4, surprise = 0.5))

test_that("is a numeric vector", {
        output <- response_unpacker(complete)
        
        expect_is(output, "numeric")
})

test_that("normal input", {
        expected <- c(0.1, 0.2, 0.3, 0.4, 0.5)
        names(expected) <- c("anger", "fear", "joy", "sadness", "surprise")
        
        output <- response_unpacker(complete)
        
        expect_equal(output, expected)
})

test_that("incomplete input", {
        incomplete <- list(results = list(anger = 0.1, joy = 0.3,
                surprise = 0.5))
        expect_error(response_unpacker(incomplete))
})

test_that("extra input", {
        extra <- list(results = list(anger = 0.1, fear = 0.2, joy = 0.3, 
                sadness = 0.4, surprise = 0.5, boredom = 0.6))
        expect_error(response_unpacker(extra))
})

test_that("empty list", {
        empty_list <- list(results = list())
        expect_error(response_unpacker(empty_list))
})

test_that("null", {
        expect_error(response_unpacker(NULL))
})

test_that("non numeric value", {
        non_nueric_value <- list(results = list(anger = 0.1, fear = 0.2,
                joy = "string", sadness = 0.4, surprise = 0.5))
        expect_error(response_unpacker(non_nueric_value))
})
