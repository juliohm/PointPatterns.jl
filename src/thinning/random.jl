# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    RandomThinning(p)

Random thinning with retention probability `p`, which can
be a constant probability value in `[0,1]` or a function
mapping a point to a probability.

## Examples

```julia
RandomThinning(0.5)
RandomThinning(p -> sum(coordinates(p)))
```
"""
struct RandomThinning{P<:Union{Real,Function}} <: ThinningMethod
  p::P
end

# -----------------------
# THINNING POINT PROCESS
# -----------------------

thin(p::PoissonProcess{<:Real}, t::RandomThinning{<:Real}) = PoissonProcess(t.p * p.λ)

thin(p::PoissonProcess{<:Function}, t::RandomThinning{<:Function}) = PoissonProcess(x -> t.p(x) * p.λ(x))

thin(p::PoissonProcess{<:Real}, t::RandomThinning{<:Function}) = PoissonProcess(x -> t.p(x) * p.λ)

thin(p::PoissonProcess{<:Function}, t::RandomThinning{<:Real}) = PoissonProcess(x -> t.p * p.λ(x))

# -----------------------
# THINNING POINT PATTERN
# -----------------------

function thin(pp::PointPattern, t::ThinningMethod)
  inds = thinning_index(pp.points, pp.marks, t)
   points = collect(view(pp.points, inds))
  marks = if pp.marks === nothing
    nothing
  else
    collect(view(pp.marks, inds))
  end
  PointPattern(PointSet(points), pp.region, marks)
end

function thin(pp::PointSet, t::ThinningMethod)
  inds = thinning_index(pp, nothing, t)
  points = collect(view(pp, inds))
  PointSet(points)
end

function thinning_index(pp::PointSet, marks::Nothing, t::RandomThinning{<:Real})
  draws = rand(Bernoulli(t.p), nelements(pp))
  findall(isequal(1), draws)
end

function thinning_index(pp::PointSet, marks::Nothing, t::RandomThinning{<:Function})
  inds = Vector{Int}()
  for j in 1:nelements(pp)
    x = element(pp, j)
    if rand(Bernoulli(t.p(x)))
      push!(inds, j)
    end
  end
  return inds
end