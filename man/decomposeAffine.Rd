% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/affine.R
\name{decomposeAffine}
\alias{decomposeAffine}
\title{Decompose an affine matrix into its constituent transformations}
\usage{
decomposeAffine(affine)
}
\arguments{
\item{affine}{A 4x4 matrix representing an affine transformation matrix.}
}
\value{
A list with components:
  \describe{
    \item{scaleMatrix}{A 3x3 matrix representing only the scale operation
      embodied in the full affine transformation.}
    \item{skewMatrix}{A 3x3 matrix representing only the skew operation
      embodied in the full affine transformation.}
    \item{rotationMatrix}{A 3x3 matrix representing only the rotation
      operation embodied in the full affine transformation.}
    \item{translation}{A length-3 named numeric vector representing the
      translations (in \code{\link{pixunits}} units) in each of the X, Y and
      Z directions.}
    \item{scales}{A length-3 named numeric vector representing the scale
      factors in each of the X, Y and Z directions. Scale factors of 1
      represent no effect.}
    \item{skews}{A length-3 named numeric vector representing the skews in
      each of the XY, XZ and YZ planes.}
    \item{angles}{A length-3 named numeric vector representing the rotation
      angles (in radians) about each of the X, Y and Z directions, i.e.,
      roll, pitch and yaw.}
  }
}
\description{
An affine matrix is composed of translation, scale, skew and rotation
transformations. This function extracts these components, after first
inverting the matrix so that it transforms from source to target space.
}
\note{
The decomposition is not perfect, and there is one particular
  degenerate case when the pitch angle is very close to \code{pi/2} radians,
  known as ``Gimbal lock''. In this case the yaw angle is arbitrarily set to
  zero.
  
  Affine matrices embodying rigid-body transformations include only 6
  degrees of freedom, rather than the full 12, so skews will always be zero
  and scales will always be unity (to within rounding error). Likewise,
  affine matrices derived from 2D registration will not include components
  relating to the Z direction.
}
\seealso{
\code{\link{buildAffine}}, \code{\link{isAffine}}
}
\author{
Jon Clayden <code@clayden.org>
}
