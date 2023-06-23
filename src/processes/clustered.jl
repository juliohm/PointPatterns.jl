# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonClusterProcess(p, o, dₒ)

A Poisson Cluster process with Poisson process `p` for parents and with
PoissonProcess `o` for offsprings. The offspring domain for each parent
point is computed by evaluating the function `dₒ` over the parent point.
"""
struct PoissonClusterProcess{P<:PoissonProcess,F<:Function} <: PointProcess
  p::P
  o::P
  dₒ::F
end

default_sampling_algorithm(::PoissonClusterProcess, ::Any) = ConstantIntensity()

function rand_single(rng::Random.AbstractRNG, p::PoissonClusterProcess, g, ::ConstantIntensity)
  # generate parents
  parents = rand(p.p, g)

  # generate offsprings
  offsprings = [rand(p.o, p.dₒ(parent)) for parent in parents]
  points = mapreduce(vcat, offsprings) do pset
    isnothing(pset) ? [] : collect(view(pset, g))
  end
  PointSet(points)
end

