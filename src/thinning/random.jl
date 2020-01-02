# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
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
  PoissonProcess(u -> t.p(u) * p.λ(u))

thin(p::PoissonProcess{<:Real}, t::RandomThinning{<:Function}) =
  PoissonProcess(u -> t.p(u) * p.λ)

thin(p::PoissonProcess{<:Function}, t::RandomThinning{<:Real}) =
  PoissonProcess(u -> t.p * p.λ(u))

# -----------------------
# thinning point pattern
# -----------------------
function thin(pp::PointPattern{T,N}, t::RandomThinning{<:Real}) where {N,T}
  # TODO
end
