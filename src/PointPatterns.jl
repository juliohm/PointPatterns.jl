# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using GeoStatsBase

using Distributions
using RecipesBase

import GeoStatsBase: coordinates

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
