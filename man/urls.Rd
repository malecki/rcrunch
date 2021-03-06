% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shoji-catalog.R, R/shoji-order-slots.R
\docType{methods}
\name{urls,ShojiCatalog-method}
\alias{urls,ShojiCatalog-method}
\alias{urls}
\alias{urls,list-method}
\alias{urls,character-method}
\alias{urls,ShojiOrder-method}
\alias{urls,OrderGroup-method}
\alias{urls,CrunchVariable-method}
\alias{urls,CrunchDataset-method}
\title{Get the URLs contained in a Catalog or Order object}
\usage{
\S4method{urls}{ShojiCatalog}(x)

\S4method{urls}{list}(x)

\S4method{urls}{character}(x)

\S4method{urls}{ShojiOrder}(x)

\S4method{urls}{OrderGroup}(x)

\S4method{urls}{CrunchVariable}(x)

\S4method{urls}{CrunchDataset}(x)
}
\arguments{
\item{x}{a Catalog, Order, or Group object}
}
\value{
A character vector of URLs
}
\description{
Sometimes it is useful to extract flattened vector of URLs from more
complex objects for purposes like subsetting or doing set comparisons.
}
\keyword{internal}
