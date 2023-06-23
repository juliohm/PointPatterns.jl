# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    ClusterProcess(proc, ofun)

A cluster process with parent process `proc` and offsprings generated
with `ofun`. It is a function that takes a parent point and returns
a point pattern from another point process.

    ClusterProcess(proc, offs, gfun)

Alternatively, specify the parent process `proc`, the offspring process
`offs` and the geometry function `gfun`. It is a function that takes a
parent point and returns a geometry or domain for the offspring process.

## Examples

```julia
# TODO
```
"""
struct ClusterProcess{P<:PointProcess,F<:Function} <: PointProcess
  proc::P
  ofun::F
end

ClusterProcess(p::PointProcess, o::PointProcess, gfun::Function) =
  ClusterProcess(p, parent -> rand(o, gfun(parent)))

defaultalgo(::ClusterProcess, ::Any) = nothing

function randsingle(rng::Random.AbstractRNG, p::ClusterProcess, g, ::Nothing)
  # retrieve parameters
  Dim = embeddim(g)
  T = coordtype(g)

  # generate parents
  parents = rand(rng, p.proc, g)

  # generate offsprings
  offsprings = p.ofun.(parents)

  # combine offsprings into single set
  points = mapreduce(vcat, offsprings) do pset
    isnothing(pset) ? Point{Dim,T}[] : collect(view(pset, g))
  end

  # return point pattern
  PointSet(points)
end

