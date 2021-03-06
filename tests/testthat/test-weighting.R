context("Weights")

with_mock_HTTP({
    oldds <- loadDataset("test ds")
    newds <- loadDataset("ECON.sav")

    test_that("Getting weights", {
        expect_null(weight(oldds))
        expect_warning(
            expect_identical(weight(newds), newds$birthyr),
            "Variable birthyr is hidden")
    })

    test_that("Setting weights", {
        expect_PATCH(weight(oldds) <- oldds$birthyr,
            "https://app.crunch.io/api/datasets/1/preferences/",
            '{"weight":"https://app.crunch.io/api/datasets/1/variables/birthyr/"}')
        expect_PATCH(weight(newds) <- NULL,
            "https://app.crunch.io/api/datasets/3/preferences/",
            '{"weight":null}')
    })
    test_that("No request is made to set a weight that already is your weight", {
        expect_no_request(weight(oldds) <- NULL)
        expect_warning(
            expect_no_request(weight(newds) <- newds$birthyr),
            "Variable birthyr is hidden")
    })

    test_that("Errors are properly handled when setting weight", {
        expect_error(weight(newds) <- "a",
            "Weight must be a Variable or NULL")
        ## test error handling when trying to set non-numeric (need backend?)
    })

    test_that("weightVariables method", {
        expect_identical(weightVariables(newds), "birthyr")
        with(temp.option(crunch.namekey.dataset="name"), {
            expect_identical(weightVariables(newds), "Birth Year")
        })
        expect_identical(weightVariables(oldds), c())
    })
})

with_test_authentication({
    with(test.dataset(df), {
        test_that("Can set weight variable", {
            expect_null(weight(ds))
            weight(ds) <- ds$v3
            expect_equivalent(weight(ds), ds$v3)
            ds <- refresh(ds)
            expect_equivalent(weight(ds), ds$v3)
            weight(ds) <- NULL
            expect_null(weight(ds))
        })

        test_that("If weight is set, computations are weighted", {
            expect_equivalent(table(ds$v4),
                structure(c(B=10, C=10), class="table"))
            weight(ds) <- ds$v3
            expect_equivalent(table(ds$v4),
                structure(c(B=sum(seq(8, 26, 2)), C=sum(seq(9, 27, 2))),
                class="table"))
        })

        test_that("If weight is set, dim() is still unweighted", {
            weight(ds) <- NULL
            expect_identical(nrow(ds), 20L)
            weight(ds) <- ds$v3
            expect_identical(nrow(ds), 20L)
            ds <- refresh(ds)
            expect_identical(nrow(ds), 20L)
        })

    })
    with(test.dataset(df), {
        test_that("We have a clean dataset", {
            expect_null(weight(ds))
        })
        test_that("Reverting to old version rolls back weight variables", {
            ds$w <- 1:20
            weight(ds) <- ds$w
            expect_equivalent(weight(ds), ds$w)
            ds <- restoreVersion(ds, 1)
            expect_null(ds$w)
            expect_null(weight(ds))
        })
        test_that("And I can add new weights because weight_variables is valid", {
            ds <- refresh(ds)
            ds$w2 <- 2:21
            weight(ds) <- ds$w2
            expect_equivalent(weight(ds), ds$w2)
        })
    })

    with(test.dataset(df), {
        test_that("I can delete my weight variable and add a new one", {
            ds$w <- 1:20
            weight(ds) <- ds$w
            expect_equivalent(weight(ds), ds$w)
            expect_true(is.Numeric(ds$w))
            expect_equivalent(as.array(crtabs(~ v4, data=ds)),
                array(c(100, 110), dim=2L, dimnames=list(v4=c("B", "C"))))
            ## Delete that variable. Confirm that it is gone and we are
            ## unweighted
            with(consent(), ds$w <- NULL)
            expect_null(weight(ds))
            expect_null(ds$w)
            expect_equivalent(as.array(crtabs(~ v4, data=ds)),
                array(c(10, 10), dim=2L, dimnames=list(v4=c("B", "C"))))
            ## Now add another weight and repeat. Confirm that we can
            ## and that calculations are weighted
            ds$w <- 20:1
            weight(ds) <- ds$w
            expect_equivalent(weight(ds), ds$w)
            expect_true(is.Numeric(ds$w))
            expect_equivalent(as.array(crtabs(~ v4, data=ds)),
                array(c(110, 100), dim=2L, dimnames=list(v4=c("B", "C"))))
            ## Now force the dataset to drop on the server and reload it
            ## to confirm that our changes were persisted correctly
            ds <- releaseAndReload(ds)
            expect_equivalent(weight(ds), ds$w)
            expect_true(is.Numeric(ds$w))
            expect_equivalent(as.array(crtabs(~ v4, data=ds)),
                array(c(110, 100), dim=2L, dimnames=list(v4=c("B", "C"))))
        })
    })

})
