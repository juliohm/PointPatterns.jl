# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using Meshes
import Meshes: _sampleweights
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
