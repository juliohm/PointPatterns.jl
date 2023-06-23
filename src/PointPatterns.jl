# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using Meshes
using GeoStatsBase

using Distributions

import Random

include("processes.jl")
include("thinning.jl")

export
  # point processes
  PointProcess,
  BinomialProcess,
  PoissonProcess,
  ClusterProcess,
  UnionProcess,
  ishomogeneous,

  # algorithms
  PointPatternAlgo,
  ConstantIntensity,
  LewisShedler,

  # thinning methods
  ThinningMethod,
  RandomThinning,
  thin

end # module
