# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module PointPatterns

using Meshes

using Distributions

import Random

include("processes.jl")
include("thinning.jl")

export
  # point processes
  PointProcess,
  BinomialProcess,
  PoissonProcess,
  InhibitionProcess,
  ClusterProcess,
  UnionProcess,
  ishomogeneous,

  # thinning methods
  ThinningMethod,
  RandomThinning,
  thin

end # module
