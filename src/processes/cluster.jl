# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    ClusterProcess(p, ofun)

A cluster process with parent process `p` and offsprings generated
with `ofun`. It is a function that takes a parent point and returns
a point pattern from another point process.

    ClusterProcess(p, o, gfun)

Alternatively, specify the parent process `p`, the offspring process `o`
and the geometry function `gfun`. It is a function that takes a parent
point and returns a geometry or domain for the offspring process.

## Examples

```julia
# TODO
```
"""
struct ClusterProcess{P<:PointProcess,F<:Function} <: PointProcess
  p::P
  ofun::F
end

ClusterProcess(p::PointProcess, o::PointProcess, gfun::Function) =
  ClusterProcess(p, parent -> rand(o, gfun(parent)))

default_sampling_algorithm(p::ClusterProcess, g) = nothing

function rand_single(rng::Random.AbstractRNG, p::ClusterProcess, g, ::Nothing)
  # retrieve parameters
  Dim = embeddim(g)
  T = coordtype(g)

  # generate parents
  parents = rand_single(rng, p.p, g)

  # generate offsprings
  offsprings = p.ofun.(parents)

  # combine offsprings into single set
  points = mapreduce(vcat, offsprings) do pset
    isnothing(pset) ? Point{Dim,T}[] : collect(view(pset, g))
  end

  # return point pattern
  PointSet(points)
end

