% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-datasets.R
\name{loadDataset}
\alias{loadDataset}
\title{Load a Crunch Dataset}
\usage{
loadDataset(dataset, kind = c("active", "all", "archived"), project = NULL,
  refresh = FALSE)
}
\arguments{
\item{dataset}{character, the name of a Crunch dataset you have access
to. Or, a \code{DatasetTuple}.}

\item{kind}{character specifying whether to look in active, archived, or all
datasets. Default is "active", i.e. non-archived.}

\item{project}{\code{CrunchProject} entity, character name of a project, or
NULL, the default. If a Project entity or reference is supplied, the
function will display datasets from that Project's datasets. If NULL,
the primary dataset catalog for the user will be used.}

\item{refresh}{logical: should the function check the Crunch API for new
datasets? Default is FALSE.}
}
\value{
An object of class \code{CrunchDataset}
}
\description{
Load a Crunch Dataset
}
