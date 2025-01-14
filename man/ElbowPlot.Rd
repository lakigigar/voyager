% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-non-spatial.R
\name{ElbowPlot}
\alias{ElbowPlot}
\title{Plot the elbow plot or scree plot for PCA}
\usage{
ElbowPlot(sce, ndims = 20, reduction = "PCA")
}
\arguments{
\item{sce}{A \code{SingleCellExperiment} object, or anything that inherits
from \code{SingleCellExperiment}.}

\item{ndims}{Number of PCs to plot.}

\item{reduction}{Name of the dimension reduction to use. It must have an
attribute called "percentVar". Defaults to "PCA".}
}
\value{
A ggplot object. The y axis is percentage of variance explained.
}
\description{
Apparently, there is no apparent way to plot the PC elbow plot other than
extracting the variance explained attribute of the dimred slot, because even
the OSCA book makes the elbow plot this way, which I find kind of cumbersome
compared to Seurat. So I'm writing this function to make the elbow plot with
SCE less cumbersome.
}
\examples{
library(SFEData)
library(scater)
sfe <- McKellarMuscleData("small")
sfe <- runPCA(sfe, ncomponents = 10, exprs_values = "counts")
ElbowPlot(sfe, ndims = 10)
}
