context("Dataset object and methods")

with_mock_HTTP({
    ds <- loadDataset("test ds")
    ds2 <- loadDataset("ECON.sav")
    ds3 <- loadDataset("an archived dataset", kind="archived")

    today <- "2016-02-11"

    test_that("Dataset can be loaded", {
        expect_true(is.dataset(ds))
    })

    test_that("Dataset attributes", {
        expect_identical(name(ds), "test ds")
        expect_identical(description(ds), "")
        expect_identical(id(ds), "511a7c49778030653aab5963")
        expect_null(notes(ds))
    })

    test_that("Dataset attribute setting", {
        expect_PATCH(name(ds) <- "New name",
            "https://app.crunch.io/api/datasets/",
            '{"https://app.crunch.io/api/datasets/1/":{"name":"New name"}}')
        expect_PATCH(notes(ds) <- "Ancillary information",
            "https://app.crunch.io/api/datasets/1/",
            '{"notes":"Ancillary information"}')
    })

    test_that("Name setting validation", {
        expect_error(name(ds) <- 3.14,
            'Names must be of class "character"')
        expect_error(name(ds) <- NULL,
            'Names must be of class "character"')
    })

    test_that("archived", {
        expect_false(is.archived(ds))
        expect_false(is.archived(ds2))
        expect_true(is.archived(ds3))
    })

    test_that("archive setting", {
        expect_PATCH(is.archived(ds2) <- TRUE,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"archived":true}}')
        expect_PATCH(archive(ds2),
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"archived":true}}')
    })

    test_that("draft/published", {
        expect_true(is.published(ds))
        expect_false(is.published(ds2))
        expect_false(is.draft(ds))
        expect_true(is.draft(ds2))
    })

    test_that("draft/publish setting", {
        expect_PATCH(is.published(ds2) <- TRUE,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"is_published":true}}')
        expect_PATCH(is.published(ds) <- FALSE,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/1/":{"is_published":false}}')
        expect_PATCH(is.draft(ds2) <- FALSE,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"is_published":true}}')
        expect_PATCH(is.draft(ds) <- TRUE,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/1/":{"is_published":false}}')
        expect_PATCH(publish(ds2),
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"is_published":true}}')
        expect_no_request(publish(ds))
        expect_no_request(is.draft(ds) <- FALSE)
        expect_no_request(is.published(ds) <- TRUE)
    })

    test_that("start/endDate", {
        expect_identical(startDate(ds), "2016-01-01")
        expect_identical(endDate(ds), "2016-01-01")
        expect_null(startDate(ds2))
        expect_null(endDate(ds2))
    })

    test_that("startDate<- makes correct request", {
        expect_PATCH(startDate(ds2) <- today,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"start_date":"2016-02-11"}}')
        expect_PATCH(startDate(ds) <- NULL,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/1/":{"start_date":null}}')
    })
    test_that("endDate<- makes correct request", {
        expect_PATCH(endDate(ds2) <- today,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/3/":{"end_date":"2016-02-11"}}')
        expect_PATCH(endDate(ds) <- NULL,
            'https://app.crunch.io/api/datasets/',
            '{"https://app.crunch.io/api/datasets/1/":{"end_date":null}}')
    })

    test_that("Dataset webURL", {
        with(temp.options(crunch.api="https://fake.crunch.io/api/v2/"), {
            expect_identical(webURL(ds),
                "https://fake.crunch.io/dataset/511a7c49778030653aab5963")
        })
    })

    test_that("Dataset VariableCatalog index is ordered", {
        expect_identical(urls(variables(ds)),
            c("https://app.crunch.io/api/datasets/1/variables/birthyr/",
            "https://app.crunch.io/api/datasets/1/variables/gender/",
            "https://app.crunch.io/api/datasets/1/variables/mymrset/",
            "https://app.crunch.io/api/datasets/1/variables/textVar/",
            "https://app.crunch.io/api/datasets/1/variables/starttime/",
            "https://app.crunch.io/api/datasets/1/variables/catarray/"))
        ## allVariables is ordered too
        expect_identical(urls(allVariables(ds)),
            c("https://app.crunch.io/api/datasets/1/variables/birthyr/",
            "https://app.crunch.io/api/datasets/1/variables/gender/",
            "https://app.crunch.io/api/datasets/1/variables/mymrset/",
            "https://app.crunch.io/api/datasets/1/variables/textVar/",
            "https://app.crunch.io/api/datasets/1/variables/starttime/",
            "https://app.crunch.io/api/datasets/1/variables/catarray/"))
    })

    test_that("namekey function exists and affects names()", {
        expect_identical(getOption("crunch.namekey.dataset"), "alias")
        expect_identical(names(ds), aliases(variables(ds)))
        with(temp.option(crunch.namekey.dataset="name"), {
            expect_identical(names(ds), names(variables(ds)))
        })
    })

    test_that("Dataset ncol doesn't make any requests", {
        with(temp.options(httpcache.log=""), {
            logs <- capture.output(nc <- ncol(ds))
        })
        expect_identical(logs, character(0))
        expect_identical(nc, 6L)
        expect_identical(dim(ds), c(25L, 6L))
    })

    test_that("Dataset has names() and extract methods work", {
        expect_false(is.null(names(ds)))
        expect_identical(names(ds),
            c("birthyr", "gender", "mymrset", "textVar", "starttime", "catarray"))
        expect_true(is.variable(ds[[1]]))
        expect_true("birthyr" %in% names(ds))
        expect_true(is.variable(ds$birthyr))
        expect_true(is.dataset(ds[2]))
        expect_identical(ds["gender"], ds[2])
        expect_identical(ds[,2], ds[2])
        expect_identical(ds[names(ds)=="gender"], ds[2])
        expect_identical(names(ds[2]), c("gender"))
        expect_identical(dim(ds[2]), c(25L, 1L))
        expect_null(ds$not.a.var.name)
        expect_error(ds[[999]], "subscript out of bounds")
    })

    ## This is a start on a test that getting variables doesn't hit server.
    ## It doesn't now, but if variable catalogs are lazily fetched, assert that
    ## we're hitting cache
    # with(temp.option(httpcache.log=""), {
    #     dlog <- capture.output({
    #         v1 <- ds$birthyr
    #         d2 <- ds[names(ds)=="gender"]
    #     })
    # })
    # print(dlog)
    # logdf <- loadLogfile(textConnection(dlog))
    # print(logdf)

    test_that("Dataset extract error handling", {
        expect_error(ds[[999]], "subscript out of bounds")
        expect_error(ds[c("gender", "NOTAVARIABLE")],
            "Undefined columns selected: NOTAVARIABLE")
        expect_null(ds$name)
    })

    test_that("Dataset logical extract cases", {
        expect_null(activeFilter(ds[TRUE,]))
        expect_error(ds[FALSE,],
            "Invalid logical filter: FALSE")
        expect_error(ds[NA,],
            "Invalid logical filter: NA")
        expect_null(activeFilter(ds[rep(TRUE, nrow(ds)),]))
        expect_error(ds[c(TRUE, FALSE),],
            "Logical filter vector is length 2, but dataset has 25 rows")
        expect_fixed_output(toJSON(activeFilter(ds[c(rep(FALSE, 4), TRUE,
            rep(FALSE, 20)),])),
            paste0('{"function":"==","args":[{"function":"row",',
            '"args":[]},{"value":4}]}'))
    })

    test_that("Extract from dataset by VariableOrder/Group", {
        ents <- c("https://app.crunch.io/api/datasets/1/variables/gender/",
            "https://app.crunch.io/api/datasets/1/variables/mymrset/")
        ord <- VariableOrder(VariableGroup("G1", entities=ents))
        expect_identical(ds[ord[[1]]], ds[c("gender", "mymrset")])
        expect_identical(ds[ord], ds[c("gender", "mymrset")])
    })

    test_that("show method", {
        expect_identical(getShowContent(ds),
            c(paste("Dataset", dQuote("test ds")),
            "",
            "Contains 25 rows of 6 variables:",
            "",
            "$birthyr: Birth Year (numeric)",
            "$gender: Gender (categorical)",
            "$mymrset: mymrset (multiple_response)",
            "$textVar: Text variable ftw (text)",
            "$starttime: starttime (datetime)",
            "$catarray: Cat Array (categorical_array)"
        ))
    })

    test_that("dataset can refresh", {
        expect_identical(ds, refresh(ds))
    })

    test_that("Dataset settings", {
        expect_false(settings(ds)$viewers_can_export)
        expect_true(settings(ds)$viewers_can_change_weight)
        expect_identical(settings(ds)$weight, self(ds$birthyr))
        expect_identical(self(settings(ds)), "https://app.crunch.io/api/datasets/1/settings/")
    })

    test_that("Changing dataset settings", {
        expect_PATCH(settings(ds)$viewers_can_export <- TRUE,
            "https://app.crunch.io/api/datasets/1/settings/",
            '{"viewers_can_export":true}')
    })
    test_that("No request made if not altering a setting", {
        expect_no_request(settings(ds)$viewers_can_export <- FALSE)
    })
    test_that("Can set a NULL setting", {
        expect_PATCH(settings(ds)$viewers_can_export <- NULL,
            "https://app.crunch.io/api/datasets/1/settings/",
            '{"viewers_can_export":null}')
    })
    test_that("Can set a variable as weight", {
        expect_PATCH(settings(ds)$weight <- ds$gender, ## Silly; server would reject, but just checking request
            "https://app.crunch.io/api/datasets/1/settings/",
            '{"weight":"https://app.crunch.io/api/datasets/1/variables/gender/"}')
    })
    test_that("Can't add a setting that doesn't exist", {
        expect_error(settings(ds)$NOTASETTING <- TRUE,
            "Invalid attribute: NOTASETTING")
    })
    test_that("Dataset deleting", {
        expect_error(delete(ds), "Must confirm") ## New non-interactive behavior
        with_consent(expect_DELETE(delete(ds), self(ds)))  ## No warning
    })

    test_that("Dashboard URL", {
        expect_null(dashboard(ds))
        expect_PATCH(dashboard(ds) <- "https://shiny.crunch.io/example/",
            "https://app.crunch.io/api/datasets/1/",
            '{"app_settings":{"whaam":',
            '{"dashboardUrl":"https://shiny.crunch.io/example/"}}}')
    })
})

with_test_authentication({
    whereas("When editing dataset metadata", {
        ds <- createDataset(name=now())
        test_that("Name and description setters push to server", {
            d2 <- ds
            name(ds) <- "Bond. James Bond."
            expect_identical(name(ds), "Bond. James Bond.")
            expect_identical(name(refresh(d2)), "Bond. James Bond.")
            description(ds) <- "007"
            expect_identical(description(ds), "007")
            expect_identical(description(refresh(d2)), "007")
            notes(ds) <- "On Her Majesty's Secret Service"
            expect_identical(notes(ds), "On Her Majesty's Secret Service")
            expect_identical(notes(refresh(d2)),
                "On Her Majesty's Secret Service")
        })

        test_that("Can unset notes and description", {
            ds <- refresh(ds)
            expect_identical(description(ds), "007")
            description(ds) <- NULL
            expect_null(description(ds))
            expect_identical(notes(ds), "On Her Majesty's Secret Service")
            notes(ds) <- NULL
            expect_null(notes(ds))
        })

        test_that("Can set (and unset) startDate", {
            startDate(ds) <- "1985-11-05"
            expect_identical(startDate(ds), "1985-11-05")
            expect_identical(startDate(refresh(ds)), "1985-11-05")
            startDate(ds) <- NULL
            expect_null(startDate(ds))
            expect_null(startDate(refresh(ds)))
        })
        test_that("Can set (and unset) endDate", {
            endDate(ds) <- "1985-11-05"
            expect_identical(endDate(ds), "1985-11-05")
            expect_identical(endDate(refresh(ds)), "1985-11-05")
            endDate(ds) <- NULL
            expect_null(endDate(ds))
            expect_null(endDate(refresh(ds)))
        })

        test_that("Can publish/unpublish a dataset", {
            expect_true(is.published(ds))
            expect_false(is.draft(ds))
            is.draft(ds) <- TRUE
            expect_false(is.published(ds))
            expect_true(is.draft(ds))
            ds <- refresh(ds)
            expect_false(is.published(ds))
            expect_true(is.draft(ds))
            is.published(ds) <- TRUE
            expect_true(is.published(ds))
            expect_false(is.draft(ds))
        })

        test_that("Can archive/unarchive", {
            expect_false(is.archived(ds))
            is.archived(ds) <- TRUE
            expect_true(is.archived(ds))
            ds <- refresh(ds)
            expect_true(is.archived(ds))
            is.archived(ds) <- FALSE
            expect_false(is.archived(ds))
        })

        test_that("Sending invalid dataset metadata errors usefully", {
            expect_error(endDate(ds) <- list(foo=4),
                "must be a string")
            expect_error(startDate(ds) <- 1985,
                "must be a string")
            skip("Improve server-side validation")
            expect_error(startDate(ds) <- "a string",
                "Useful error message here")
        })

        ds$name <- 1:2
        test_that("A variable named/aliased 'name' can be accessed", {
            expect_true("name" %in% aliases(variables(ds)))
            expect_true("name" %in% names(ds))
            expect_true(is.Numeric(ds$name))
        })

        test_that("Dataset settings (defaults)", {
            # expect_true(settings(ds)$viewers_can_export) ## Isn't it?
            expect_true(settings(ds)$viewers_can_change_weight)
            expect_null(settings(ds)$weight)
        })

        test_that("Setting and unsetting dataset settings", {
            settings(ds)$viewers_can_change_weight <- FALSE
            expect_false(settings(ds)$viewers_can_change_weight)
            skip("Can't set this setting to NULL to reset it to default")
            settings(ds)$viewers_can_change_weight <- NULL
            ## Go back to default
            expect_true(settings(ds)$viewers_can_change_weight)
        })
        test_that("Setting default weight", {
            settings(ds)$weight <- self(ds$name)
            expect_identical(settings(ds)$weight, self(ds$name))
            ## And it should now be in the weight variables order too
            expect_identical(urls(ShojiOrder(crGET(shojiURL(variables(ds),
                "orders", "weights")))), self(ds$name))
            ## Can also remove the setting
            settings(ds)$weight <- NULL
            expect_null(settings(ds)$weight)
        })
        test_that("Junk input validation for settings", {
            expect_error(settings(ds)$weight <- self(ds))
            expect_error(settings(ds)$viewers_can_export <- list(foo="bar"))
        })
    })

    with(test.dataset(df), {
        test_that("dataset dim", {
            expect_identical(dim(ds), dim(df))
            expect_identical(nrow(ds), nrow(df))
            expect_identical(ncol(ds), ncol(df))
        })

        test_that("Dataset [[<-", {
            v1 <- ds$v1
            name(v1) <- "Variable One"
            ds$v1 <- v1
            expect_identical(names(variables(ds))[1], "Variable One")
            expect_error(ds$v2 <- v1,
                "Cannot overwrite one Variable")
        })
    })

    with(test.dataset(mrdf), {
        cast.these <- grep("mr_", names(ds))
        test_that("Dataset [<-", {
            expect_true(all(vapply(variables(ds)[cast.these],
                function (x) x$type == "numeric", logical(1))))
            expect_true(all(vapply(ds[cast.these],
                function (x) is.Numeric(x), logical(1))))
            ds[cast.these] <- lapply(ds[cast.these],
                castVariable, "categorical")
            expect_true(all(vapply(variables(ds)[cast.these],
                function (x) x$type == "categorical", logical(1))))
            expect_true(all(vapply(ds[cast.these],
                function (x) is.Categorical(x), logical(1))))
        })
        test_that("Dataset [[<- on new array variable", {
            ds$arrayVar <- makeArray(ds[cast.these], name="Array variable")
            expect_true(is.CA(ds$arrayVar))
            expect_identical(name(ds$arrayVar), "Array variable")
        })
    })
})
