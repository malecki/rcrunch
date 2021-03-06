context("Consent")

test_that("askForPermission says no if not interactive", {
    expect_false(askForPermission())
})

test_that("when interactive, aFP with user input (mocked)", {
    with_fake_input("y", expect_true(askForPermission()))
    with_fake_input("n", expect_false(askForPermission()))
})

test_that("consent", {
    expect_false(askForPermission()) ## Because not interactive running
    with(consent(), {
        expect_true(askForPermission())
    })
    expect_false(askForPermission())
})

test_that("with_consent", {
    expect_false(askForPermission()) ## Because not interactive running
    with_consent(expect_true(askForPermission()))
    expect_false(askForPermission())
})
