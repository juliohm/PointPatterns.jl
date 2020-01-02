# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    UnionProcess(p₁, p₂)

Union (or superposition) of spatial point processes `p₁` and `p₂`.
"""
struct UnionProcess{P₁<:PointProcess,P₂<:PointProcess} <: PointProcess
  p₁::P₁
  p₂::P₂
end

function rand_single(p::UnionProcess, r::AbstractRegion)
  pp₁ = rand(p.p₁, r)
  pp₂ = rand(p.p₂, r)

  X = coordinates(pp₁)
  Y = coordinates(pp₂)

  PointPattern(hcat(X, Y))
end
