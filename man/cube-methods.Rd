% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cube-dims.R, R/cube-result.R
\docType{methods}
\name{cube-methods}
\alias{cube-methods}
\alias{dimensions}
\alias{dimnames,CubeDims-method}
\alias{dim,CubeDims-method}
\alias{is.na,CubeDims-method}
\alias{dimensions,CrunchCube-method}
\alias{variables,CubeDims-method}
\alias{variables,CrunchCube-method}
\alias{dim,CrunchCube-method}
\alias{dimnames,CrunchCube-method}
\alias{names,CrunchCube-method}
\alias{aliases,CrunchCube-method}
\alias{descriptions,CrunchCube-method}
\title{Methods on Cube objects}
\usage{
\S4method{dimnames}{CubeDims}(x)

\S4method{dim}{CubeDims}(x)

\S4method{is.na}{CubeDims}(x)

\S4method{dimensions}{CrunchCube}(x)

\S4method{variables}{CubeDims}(x)

\S4method{variables}{CrunchCube}(x)

\S4method{dim}{CrunchCube}(x)

\S4method{dimnames}{CrunchCube}(x)

\S4method{names}{CrunchCube}(x)

\S4method{aliases}{CrunchCube}(x)

\S4method{descriptions}{CrunchCube}(x)
}
\arguments{
\item{x}{a CrunchCube or its CubeDims component.}
}
\value{
Generally, the same shape of result that each of these functions
return when applied to an \code{array} object.
}
\description{
These methods provide an \code{array}-like interface to the CrunchCube
object.
}
\seealso{
\code{\link{cube-computing}}
}
