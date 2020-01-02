# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    RandomThinning(p)

Random thining with retention probability `p`.
"""
struct RandomThinning{T<:Real} <: AbstractThinning
  p::T
end

function thin(p::PointProcess, t::RandomThinning)
  # TODO
end
