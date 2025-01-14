# Univariate, from spdep

#' Univariate spatial stiatistics
#'
#' These functions compute univariate spatial statistics, both global and local,
#' on matrices, data frames, and SFE objects. For SFE objects, the statistics
#' can be computed for numeric columns of \code{colData}, \code{colGeometries},
#' and \code{annotGeometries}, and the results are stored within the SFE object.
#' \code{calculateMoransI} and \code{runMoransI} are convenience wrappers for
#' \code{calculateUnivariate} and \code{runUnivariate} respectively.
#'
#' Most univariate methods in the package \code{spdep} are supported here. These
#' methods are global, meaning returning one result for all spatial locations in
#' the dataset: \code{\link[spdep]{moran}}, \code{\link[spdep]{geary}},
#' \code{\link[spdep]{moran.mc}}, \code{\link[spdep]{geary.mc}},
#' \code{\link[spdep]{moran.test}}, \code{\link[spdep]{geary.test}},
#' \code{\link[spdep]{globalG.test}}, \code{\link[spdep]{sp.correlogram}}.
#'
#' The following methods are local, meaning each location has its own results:
#' \code{\link[spdep]{moran.plot}}, \code{\link[spdep]{localmoran}},
#' \code{\link[spdep]{localmoran_perm}}, \code{\link[spdep]{localC}},
#' \code{\link[spdep]{localC_perm}}, \code{\link[spdep]{localG}},
#' \code{\link[spdep]{localG_perm}}, \code{\link[spdep]{LOSH}},
#' \code{\link[spdep]{LOSH.mc}}, \code{\link[spdep]{LOSH.cs}}. The
#' \code{GWmodel::gwss} method will be supported soon, but is not supported yet.
#'
#' Global results for genes are stored in \code{rowData}. For \code{colGeometry}
#' and \code{annotGeometry}, the results are added to an attribute of the data
#' frame called \code{featureData}, which is a DataFrame analogous to
#' \code{rowData} for the gene count matrix. New column names in
#' \code{featureData} would follow the same rules as in \code{rowData}. For
#' \code{colData}, the results can be accessed with the \code{colFeatureData}
#' function.
#'
#' Local results are stored in the field \code{localResults} field of the SFE
#' object, which can be accessed with
#' \code{\link[SpatialFeatureExperiment]{localResults}} or
#' \code{\link[SpatialFeatureExperiment]{localResult}}. If the results have
#' p-values, then -log10 p and Benjamin-Hochberg corrected -log10 p are added.
#' Note that in the multiple testing correction, \code{\link[spdep]{p.adjustSP}}
#' is used.
#'
#' @inheritParams spdep::moran
#' @inheritParams SpatialFeatureExperiment::localResults
#' @param x A numeric matrix whose rows are features/genes, or a
#'   \code{SpatialFeatureExperiment} (SFE) object with such a matrix in an
#'   assay.
#' @param listw Weighted neighborhood graph as a \code{spdep} \code{listw}
#'   object.
#' @param features Genes (\code{calculate*} SFE method and \code{run*}) or
#'   numeric columns of \code{colData(x)} (\code{colData*}) or any
#'   \code{\link{colGeometry}} (\code{colGeometry*}) or
#'   \code{\link{annotGeometry}} (\code{annotGeometry*}) for which the
#'   univariate metric is to be computed. Default to \code{NULL}. When
#'   \code{NULL}, then the metric is computed for all genes with the values in
#'   the assay specified in the argument \code{exprs_values}. This can be
#'   parallelized with the argument \code{BPPARAM}. For genes, if the column
#'   "symbol" is present in \code{rowData} and the row names of the SFE object
#'   are Ensembl IDs, then the gene symbol can be used and converted to IDs
#'   behind the scene. However, if one symbol matches multiple IDs, a warning
#'   will be given and the first match will be used. Internally, the results are
#'   always stored by the Ensembl ID rather than symbol.
#' @param exprs_values Integer scalar or string indicating which assay of x
#'   contains the expression values.
#' @param BPPARAM A \code{\link{BiocParallelParam}} object specifying whether
#'   and how computing the metric for numerous genes shall be parallelized.
#' @param colGraphName Name of the listw graph in the SFE object that
#'   corresponds to entities represented by columns of the gene count matrix.
#'   Use \code{\link{colGraphNames}} to look up names of the available graphs
#'   for cells/spots. Note that for multiple \code{sample_id}s, it is assumed
#'   that all of them have a graph of this same name.
#' @param annotGraphName Name of the listw graph in the SFE object that
#'   corresponds to the \code{annotGeometry} of interest. Use
#'   \code{\link{annotGraphNames}} to look up names of available annotation
#'   graphs.
#' @param colGeometryName Name of a \code{colGeometry} \code{sf} data frame
#'   whose numeric columns of interest are to be used to compute the metric. Use
#'   \code{\link{colGeometryNames}} to look up names of the \code{sf} data
#'   frames associated with cells/spots.
#' @param annotGeometryName Name of a \code{annotGeometry} \code{sf} data frame
#'   whose numeric columns of interest are to be used to compute the metric. Use
#'   \code{\link{annotGeometryNames}} to look up names of the \code{sf} data
#'   frames associated with annotations.
#' @param sample_id Sample(s) in the SFE object whose cells/spots to use. Can be
#'   "all" to compute metric for all samples; the metric is computed separately
#'   for each sample.
#' @param returnDF Logical, when the results are not added to a SFE object,
#'   whether the results should be formatted as a \code{DataFrame}.
#' @param include_self Logical, whether the spatial neighborhood graph should
#'   include edges from each location to itself. This is for Getis-Ord Gi* as in
#'   \code{localG} and \code{localG_perm}, not to be used for any other method.
#' @param p.adjust.method Method to correct for multiple testing, passed to
#'   \code{\link[spdep]{p.adjustSP}}. Methods allowed are in
#'   \code{\link{p.adjust.methods}}.
#' @param ... Other arguments passed to S4 method (for convenience wrappers like
#'   \code{calculateMoransI}) or method used to compute metrics as specified by
#'   the argument \code{type} (as in more general functions like
#'   \code{calculateUnivariate}). See documentation in the \code{spdep} package
#'   for the latter.
#' @return In \code{calculateUnivariate}, if \code{returnDF = TRUE}, then a
#'   \code{DataFrame}, otherwise a list each element of which is the results for
#'   each feature. For \code{run*}, a \code{SpatialFeatureExperiment} object
#'   with the results added. See Details for where the results are stored.
#' @name calculateUnivariate
#' @aliases calculateMoransI
#' @importFrom spdep moran geary Szero moran.mc geary.mc moran.test geary.test
#'   globalG.test sp.correlogram moran.plot localmoran localmoran_perm localC
#'   localC_perm localG localG_perm LOSH LOSH.mc LOSH.cs
#' @importFrom BiocParallel SerialParam bplapply
#' @importFrom S4Vectors DataFrame
#' @importClassesFrom SpatialFeatureExperiment SpatialFeatureExperiment
#' @importFrom SummarizedExperiment assay rowData<-
#' @importFrom SpatialFeatureExperiment colGraph annotGraph localResults<-
#' @importFrom SingleCellExperiment colData rowData
#' @examples
#' library(SpatialFeatureExperiment)
#' library(SingleCellExperiment)
#' library(SFEData)
#' sfe <- McKellarMuscleData("small")
#' colGraph(sfe, "visium") <- findVisiumGraph(sfe)
#' features_use <- rownames(sfe)[1:5]
#'
#' # Moran's I
#' moran_results <- calculateMoransI(sfe,
#'     features = features_use,
#'     colGraphName = "visium",
#'     exprs_values = "counts"
#' )
#'
#' # This does not advocate for computing Moran's I on raw counts.
#' # Just an example for function usage.
#'
#' sfe <- runMoransI(sfe,
#'     features = features_use, colGraphName = "visium",
#'     exprs_values = "counts"
#' )
#' # Look at the results
#' head(rowData(sfe))
#'
#' # Local Moran's I
#' sfe <- runUnivariate(sfe,
#'     type = "localmoran", features = features_use,
#'     colGraphName = "visium", exprs_values = "counts"
#' )
#' head(localResult(sfe, "localmoran", features_use[1]))
#'
#' # For colData
#' sfe <- colDataUnivariate(sfe,
#'     type = "localmoran", features = "nCounts",
#'     colGraphName = "visium"
#' )
#' head(localResult(sfe, "localmoran", "nCounts"))
#'
#' # For annotGeometries
#' annotGraph(sfe, "myofiber_tri2nb") <-
#'     findSpatialNeighbors(sfe,
#'         type = "myofiber_simplified", MARGIN = 3L,
#'         method = "tri2nb", dist_type = "idw",
#'         zero.policy = TRUE
#'     )
#' sfe <- annotGeometryUnivariate(sfe,
#'     type = "localG", features = "area",
#'     annotGraphName = "myofiber_tri2nb",
#'     annotGeometryName = "myofiber_simplified",
#'     zero.policy = TRUE
#' )
#' head(localResult(sfe, "localG", "area",
#'     annotGeometryName = "myofiber_simplified"
#' ))
NULL

#' @rdname calculateUnivariate
#' @export
setMethod(
    "calculateUnivariate", "ANY",
    function(x, listw, type = c(
                 "moran", "geary", "moran.mc", "geary.mc",
                 "moran.test", "geary.test", "globalG.test",
                 "sp.correlogram", "moran.plot", "localmoran",
                 "localmoran_perm", "localC", "localC_perm",
                 "localG", "localG_perm", "LOSH", "LOSH.mc", "LOSH.cs",
                 "gwss"
             ),
             BPPARAM = SerialParam(),
             zero.policy = NULL, returnDF = TRUE, p.adjust.method = "BH", ...) {
        type <- match.arg(type)
        # I wrote a thin wrapper to make the argument names consistent
        if (type == "sp.correlogram") {
            fun <- .sp.correlogram
        } else {
            fun <- match.fun(type)
        }
        local <- .is_local(type)
        obscure_args <- switch(type,
            moran = c("n", "S0"),
            geary = c("n", "n1", "S0")
        )
        defaults <- .obscure_arg_defaults(listw, type)
        other_args <- list(...)
        defaults_use <- defaults[setdiff(names(defaults), names(other_args))]
        all_args <- list(
            x = x, listw = listw, fun = fun,
            BPPARAM = BPPARAM, zero.policy = zero.policy
        )
        all_args <- c(all_args, other_args, defaults_use)
        out <- do.call(.calc_univar, all_args)
        if (returnDF) out <- .res2df(out, type, local, nb = listw$neighbours,
                                     p.adjust.method = p.adjust.method, ...)
        out
    }
)

#' @rdname calculateUnivariate
#' @export
setMethod(
    "calculateUnivariate", "SpatialFeatureExperiment",
    .calc_univar_sfe_fun()
)

#' @rdname calculateUnivariate
#' @export
setMethod(
    "calculateMoransI", "ANY",
    function(x, ..., BPPARAM = SerialParam(), zero.policy = NULL) {
        calculateUnivariate(x,
            type = "moran", BPPARAM = BPPARAM,
            zero.policy = zero.policy, ...
        )
    }
)

#' @rdname calculateUnivariate
#' @export
setMethod(
    "calculateMoransI", "SpatialFeatureExperiment",
    .calc_univar_sfe_fun(type = "moran")
)

#' @rdname calculateUnivariate
#' @export
colDataUnivariate <- .coldata_univar_fun()

#' @rdname calculateUnivariate
#' @export
colDataMoransI <- .coldata_univar_fun(type = "moran")

#' @rdname calculateUnivariate
#' @export
colGeometryUnivariate <- .colgeom_univar_fun()

#' @rdname calculateUnivariate
#' @export

colGeometryMoransI <- .colgeom_univar_fun(type = "moran")

#' @rdname calculateUnivariate
#' @export
annotGeometryUnivariate <- .annotgeom_univar_fun()

#' @rdname calculateUnivariate
#' @export
annotGeometryMoransI <- .annotgeom_univar_fun(type = "moran")

#' @rdname calculateUnivariate
#' @export
runUnivariate <- .sfe_univar_fun()

#' @rdname calculateUnivariate
#' @export
runMoransI <- .sfe_univar_fun(type = "moran")
