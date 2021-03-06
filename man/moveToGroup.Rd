% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shoji-order.R
\name{moveToGroup}
\alias{moveToGroup}
\alias{moveToGroup<-}
\title{Move entities to a group}
\usage{
moveToGroup(x, value)

moveToGroup(x) <- value
}
\arguments{
\item{x}{VariableGroup}

\item{value}{Variable, VariableCatalog subset, or Dataset subset}
}
\value{
\code{x} with the entities in \code{value} appended to it. If the
containing order object has duplicates=FALSE, the entities will be "moved"
to this group. Otherwise, their references will be copied to the group.
}
\description{
The function has two versions: a regular function and a setter. They do the
same thing, but the setter probably results in less verbose code for you.
}
\examples{
\dontrun{
moveToGroup(ordering(ds)[["Demographics"]]) <- ds[c("gender", "age")]
}
}
