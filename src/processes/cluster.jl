# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   ClusterProcess(p, ofun)

A cluster process with parent process `p` and offsprings generated
with `ofun`. It is a function that take a parent point and generates
a set of offspring points as a PointSet.
"""
struct ClusterProcess{P<:PointProcess,F<:Function} <: PointProcess
  p::P
  ofun::F
end

function ClusterProcess(p::PointProcess, o::PointProcess, gfun::Function)
  ClusterProcess(p, parent -> rand(o, gfun(parent)))
end

function ClusterProcess(p::PointProcess, o::PoissonProcess{<:Function}, gfun::Function; centered = true)
  if centered
    ClusterProcess(p, parent -> rand(PoissonProcess(x -> o.λ(Point(x - parent))), gfun(parent)))
  else
    ClusterProcess(p, parent -> rand(o, gfun(parent)))
  end
end

default_sampling_algorithm(p::ClusterProcess, g) = default_sampling_algorithm(p.p, g)

function rand_single(rng::Random.AbstractRNG, p::ClusterProcess, g, algo::PointPatternAlgo)
  # generate parents
  parents = rand_single(rng, p.p, g, algo)

  # generate offsprings
  offsprings = [p.ofun(parent) for parent in parents]

  # combine offsprings into single set
  points = mapreduce(vcat, offsprings) do pset
    isnothing(pset) ? [] : collect(view(pset, g))
  end

  PointSet{2,Float64}(points)
end

