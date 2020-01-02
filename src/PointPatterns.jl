# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using GeoStatsBase

using Distributions: Uniform, Poisson, product_distribution
using StaticArrays: SVector, MVector

import GeoStatsBase: npoints, coordinates, coordinates!

include("pattern.jl")
include("processes.jl")

export
  # point pattern
  PointPattern,
  npoints,
  coordinates,
  coordinates!,

  # point processes
  PointProcess,
  BinomialProcess,
  PoissonProcess,
  UnionProcess,
  ishomogeneous

end # module
