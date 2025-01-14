% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/univariate-downstream.R
\name{clusterCorrelograms}
\alias{clusterCorrelograms}
\title{Find clusters of correlogram patterns}
\usage{
clusterCorrelograms(
  sfe,
  features,
  BLUSPARAM,
  sample_id = NULL,
  method = "I",
  colGeometryName = NULL,
  annotGeometryName = NULL,
  show_symbol = TRUE
)
}
\arguments{
\item{sfe}{A \code{SpatialFeatureExperiment} object with correlograms
computed for features of interest.}

\item{features}{Features whose correlograms to cluster.}

\item{BLUSPARAM}{A \linkS4class{BlusterParam} object specifying the algorithm to use.}

\item{sample_id}{Sample(s) in the SFE object whose cells/spots to use. Can be
"all" to compute metric for all samples; the metric is computed separately
for each sample.}

\item{method}{"corr" for correlation, "I" for Moran's I, "C" for Geary's C}

\item{colGeometryName}{Name of colGeometry from which to look for features.}

\item{annotGeometryName}{Name of annotGeometry from which to look for
features.}

\item{show_symbol}{Logical, whether to show gene symbol instead when Ensembl
ID is supplied.}
}
\value{
A \code{DataFrame} with 3 columns: \code{feature} for the features,
\code{cluster} a factor for cluster membership of the features within each
sample, and \code{sample_id} for the sample.
}
\description{
Cluster the correlograms to find patterns in length scales of spatial
autocorrelation. All the correlograms clustered must be computed with the
same method and have the same number of lags.
}
\examples{
library(SpatialFeatureExperiment)
library(SFEData)
library(bluster)
sfe <- McKellarMuscleData("small")
colGraph(sfe, "visium") <- findVisiumGraph(sfe)
inds <- c(1, 3, 4, 5)
sfe <- runUnivariate(sfe,
    type = "sp.correlogram",
    features = rownames(sfe)[inds],
    exprs_values = "counts", order = 5
)
clust <- clusterCorrelograms(sfe,
    features = rownames(sfe)[inds],
    BLUSPARAM = KmeansParam(2)
)
}
