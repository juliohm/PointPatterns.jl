# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   ClusterProcess(p, o, d)

A cluster process with process `p` for parents and with process `o` for
offsprings. The offspring domain for each parent point is computed by
evaluating the function `d` over the parent point.
"""
struct ClusterProcess{P<:PointProcess,F<:Function} <: PointProcess
  p::P
  o::P
  d::F
end

default_sampling_algorithm(::ClusterProcess, ::Any) = ConstantIntensity()

function rand_single(rng::Random.AbstractRNG, p::ClusterProcess, g, ::ConstantIntensity)
  # generate parents
  parents = rand(p.p, g)

  # generate offsprings
  offsprings = [rand(p.o, p.d(parent)) for parent in parents]

  # combine offsprings into single set
  points = mapreduce(vcat, offsprings) do pset
    isnothing(pset) ? [] : collect(view(pset, g))
  end

  PointSet(points)
end

