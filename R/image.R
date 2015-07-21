#' Test whether an object represents an image
#' 
#' This function tried to determine whether an object is an image that the
#' package knows how to handle. If its class is \code{"nifti"} or
#' \code{"internalImage"} then the result is always \code{TRUE}. Likewise if
#' it has an internal image pointer. If it has no \code{dim} attribute or
#' looks like an affine matrix then the result is \code{FALSE}. Otherwise the
#' value of the \code{unsure} argument is returned.
#' 
#' @param object An R object.
#' @param unsure The value to return if the function can't tell whether or not
#'   the \code{object} is an image.
#' 
#' @author Jon Clayden <code@@clayden.org>
#' @export
isImage <- function (object, unsure = NA)
{
    if (any(c("nifti","internalImage") %in% class(object)))
        return (TRUE)
    else if (!is.null(attr(object, ".nifti_image_ptr")))
        return (TRUE)
    else if (is.null(dim(object)))
        return (FALSE)
    else if (isAffine(object))
        return (FALSE)
    else
        return (unsure)
}


#' Internal images
#' 
#' An internal image is a simple R object with a few attributes including a
#' pointer to an internal C structure, which contains the full image data. They
#' are used in the package for efficiency, but can be converted to a normal
#' R array using the \code{as.array} method.
#' 
#' @param x An \code{"internalImage"} object.
#' @param ... Additional parameters to methods. Currently unused.
#' 
#' @author Jon Clayden <code@@clayden.org>
#' @aliases internalImage
#' @rdname internalImage
#' @export
dim.internalImage <- function (x)
{
    return (attr(x, "imagedim"))
}


#' @rdname internalImage
#' @export
as.array.internalImage <- function (x, ...)
{
    return (.Call("pointerToArray", x, PACKAGE="RNiftyReg"))
}


#' @rdname internalImage
#' @export
print.internalImage <- function (x, ...)
{
    dim <- attr(x, "imagedim")
    ndim <- length(dim)
    pixdim <- attr(x, "pixdim")
    pixunits <- attr(x, "pixunits")
    cat(paste0("Internal image: \"", x, "\"\n"))
    cat(paste("-", paste(dim,collapse=" x "), ifelse(ndim>2,"voxels\n","pixels\n")))
    
    if (!is.null(pixdim))
    {
        spaceUnit <- grep("m$", pixunits, perl=TRUE, value=TRUE)
        cat(paste("-", paste(signif(pixdim[1:min(3,ndim)],4),collapse=" x ")))
        if (length(spaceUnit) > 0)
            cat(paste0(" ", spaceUnit[1]))
        
        if (ndim > 3)
        {
            timeUnit <- grep("s$", pixunits, perl=TRUE, value=TRUE)
            cat(paste(" x", signif(pixdim[4],4)))
            if (length(timeUnit) > 0)
                cat(paste0(" ", timeUnit[1]))
        }
        if (ndim > 4)
            cat(paste(" x", paste(signif(pixdim[5:ndim],4),collapse=" x ")))
        
        cat(paste(" per", ifelse(ndim>2,"voxel\n","pixel\n")))
    }
}


#' Number of dimensions
#' 
#' This function is shorthand for \code{length(dim(object))}.
#' 
#' @param object An R object.
#' @return The dimensionality of the object. Objects without a \code{dim}
#'   attribute will produce zero.
#' 
#' @author Jon Clayden <code@@clayden.org>
#' @export
ndim <- function (object)
{
    length(dim(object))
}


#' Pixel dimensions and units
#' 
#' These functions return the \code{"pixdim"} and \code{"pixunits"} attributes
#' of their arguments. These represent the physical step size between pixel or
#' voxel centre points, and the spatial and temporal units that they are given
#' in. The former defaults to 1 in each dimension, if there is no attribute.
#' 
#' @param object An R object, generally an image.
#' @return \code{pixdim} returns a numeric vector of pixel dimensions.
#'   \code{pixunits} returns a character vector of length up to two, giving the
#'   spatial and temporal unit names.
#' 
#' @author Jon Clayden <code@@clayden.org>
#' @export
pixdim <- function (object)
{
    if (!is.null(attr(object, "pixdim")))
        return (attr(object, "pixdim"))
    else if (!is.null(dim(object)))
        return (rep(1, length(dim(object))))
    else
        return (1)
}


#' @rdname pixdim
#' @export
pixunits <- function (object)
{
    if (!is.null(attr(object, "pixunits")))
        return (attr(object, "pixunits"))
    else
        return ("Unknown")
}