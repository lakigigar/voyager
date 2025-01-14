% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-non-spatial.R
\name{plotColDataBin2D}
\alias{plotColDataBin2D}
\alias{plotRowDataBin2D}
\title{Plot colData and rowData with 2D histograms}
\usage{
plotColDataBin2D(
  sfe,
  x,
  y,
  subset = NULL,
  bins = 100,
  binwidth = NULL,
  hex = FALSE,
  name_true = NULL,
  name_false = NULL
)

plotRowDataBin2D(
  sfe,
  x,
  y,
  subset = NULL,
  bins = 100,
  binwidth = NULL,
  hex = FALSE,
  name_true = NULL,
  name_false = NULL
)
}
\arguments{
\item{sfe}{A \code{SpatialFeatureExperiment} object.}

\item{x}{Name of the column in \code{colData} or \code{rowData} to plot on
the x axis of the plot.}

\item{y}{Name of the column in \code{colData} or \code{rowData} to plot on
the y axis of the plot.}

\item{subset}{Name of a logical column in \code{colData} or \code{rowData},
indicating cells or genes to plot with a different palette. Since the 2D
histogram is effectively an opaque heatmap, don't use this argument unless
the two groups are largely non-overlapping in the variables being plotted.}

\item{bins}{Numeric vector giving number of bins in both vertical and
horizontal directions. Set to 100 by default.}

\item{binwidth}{Numeric vector giving bin width in both vertical and
horizontal directions. Overrides \code{bins} if both set.}

\item{hex}{Logical, whether to use hexagon rather than rectangular bins.
Requires the \code{hexbin} package.}

\item{name_true}{Character, name to show on the legend for cells or genes
indicated \code{TRUE} in the \code{subset} argument.}

\item{name_false}{Character, name to show on the legend for cells or genes
indicated \code{FALSE} in the \code{subset} argument.}
}
\value{
A ggplot object
}
\description{
To avoid overplotting in large datasets. The 2D histogram is more informative
of point density on the plot than the scatter plot where there are so many
points plotted that they effectively form a solid block.
}
\examples{
library(SFEData)
sfe <- McKellarMuscleData()
sfe <- sfe[, sfe$in_tissue]
plotColDataBin2D(sfe, "nCounts", "nGenes")
}
