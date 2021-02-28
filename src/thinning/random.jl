# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    RandomThinning(p)

Random thining with retention probability `p`.
"""
struct RandomThinning{P<:Union{Real,Function}} <: AbstractThinning
  p::P
end

# -----------------------
# thinning point process
# -----------------------
thin(p::PoissonProcess{<:Real}, t::RandomThinning{<:Real}) =
  PoissonProcess(t.p * p.λ)

thin(p::PoissonProcess{<:Function}, t::RandomThinning{<:Function}) =
  PoissonProcess(x -> t.p(x) * p.λ(x))

thin(p::PoissonProcess{<:Real}, t::RandomThinning{<:Function}) =
  PoissonProcess(x -> t.p(x) * p.λ)

thin(p::PoissonProcess{<:Function}, t::RandomThinning{<:Real}) =
  PoissonProcess(x -> t.p * p.λ(x))

# -----------------------
# thinning point pattern
# -----------------------
function thin(pp::PointSet, t::RandomThinning{<:Real})
  draws = rand(Bernoulli(t.p), nelements(pp))
  inds  = findall(isequal(1), draws)
  PointSet(coordinates(pp, inds))
end

function thin(pp::PointSet, t::RandomThinning{<:Function})
  inds = Vector{Int}()
  for j in 1:nelements(pp)
    x = coordinates(pp, j)
    if rand(Bernoulli(t.p(x)))
      push!(inds, j)
    end
  end
  PointSet(coordinates(pp, inds))
end
