% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shoji-order-slots.R
\docType{methods}
\name{ShojiOrder-slots}
\alias{ShojiOrder-slots}
\alias{entities}
\alias{entities<-}
\alias{duplicates}
\alias{duplicates<-}
\alias{entities,OrderGroup-method}
\alias{entities,ShojiOrder-method}
\alias{entities,list-method}
\alias{entities<-,OrderGroup-method}
\alias{entities<-,ShojiOrder-method}
\alias{name,OrderGroup-method}
\alias{name<-,OrderGroup-method}
\alias{names,ShojiOrder-method}
\alias{names,OrderGroup-method}
\alias{names<-,ShojiOrder-method}
\alias{duplicates,ShojiOrder-method}
\alias{duplicates,OrderGroup-method}
\alias{duplicates,VariableCatalog-method}
\alias{duplicates<-,ShojiOrder,logical-method}
\alias{duplicates<-,OrderGroup,logical-method}
\alias{duplicates<-,VariableCatalog,logical-method}
\title{Manipulate VariableGroup and VariableOrder}
\usage{
\S4method{entities}{OrderGroup}(x, simplify = FALSE)

\S4method{entities}{ShojiOrder}(x, simplify = FALSE)

\S4method{entities}{list}(x, simplify = FALSE)

\S4method{entities}{OrderGroup}(x) <- value

\S4method{entities}{ShojiOrder}(x) <- value

\S4method{name}{OrderGroup}(x)

\S4method{name}{OrderGroup}(x) <- value

\S4method{names}{ShojiOrder}(x)

\S4method{names}{OrderGroup}(x)

\S4method{names}{ShojiOrder}(x) <- value

\S4method{duplicates}{ShojiOrder}(x)

\S4method{duplicates}{OrderGroup}(x)

\S4method{duplicates}{VariableCatalog}(x)

\S4method{duplicates}{ShojiOrder,logical}(x) <- value

\S4method{duplicates}{OrderGroup,logical}(x) <- value

\S4method{duplicates}{VariableCatalog,logical}(x) <- value
}
\arguments{
\item{x}{a VariableGroup or VariableOrder}

\item{simplify}{logical: should variable URLs inside of groups be flattened
or preserved in their nested lists? Default is \code{FALSE}.}

\item{value}{(1) For name, a character (length-1 vector); for names, a character
vector of equal length to the number of VariableGroups beind modified; for
entities, either a character vector of variable URLs or a list containing a
combination of variable URLs and VariableGroups. Note that group names must
be unique, should be greater than 0 characters long, and "ungrouped" is a
reserved group name. (2) For duplicates, logical for whether duplicate
variable entries should be allowed in the VariableOrder.}
}
\value{
\code{entities} returns Variable references and VariableGroups; \code{names} returns group names; \code{duplicates} returns logical for whether duplicate variable entries should be allowed
}
\description{
Manipulate VariableGroup and VariableOrder
}
\seealso{
\code{\link{VariableOrder}}

\code{\link{grouped}}
}
