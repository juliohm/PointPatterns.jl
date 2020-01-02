# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using GeoStatsBase

using Distributions: Uniform, Poisson, product_distribution
using StaticArrays: SVector, MVector
using RecipesBase

import GeoStatsBase: npoints, coordinates, coordinates!

include("pattern.jl")
include("processes.jl")
include("thinning.jl")

# plot recipes
include("plotrecipes/pattern.jl")

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
  ishomogeneous,

  # thinning methods
  AbstractThinning,
  RandomThinning,
  thin

end # module
