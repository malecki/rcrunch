% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crunchbox.R
\name{crunchBox}
\alias{crunchBox}
\title{Make a CrunchBox}
\usage{
crunchBox(dataset, filters = crunch::filters(dataset), ...)
}
\arguments{
\item{dataset}{CrunchDataset}

\item{filters}{FilterCatalog, or \code{NULL} for no filters. Default all
filters in your catalog, \code{filters(dataset)}.}

\item{...}{additional metadata for the box, such as "title", "header", etc.}
}
\value{
The URL to the newly created box.
}
\description{
CrunchBoxes allow you to publish results to the world.
}
\seealso{
\code{\link{preCrunchBoxCheck}} to provide guidance on what you're including in the CrunchBox
}
