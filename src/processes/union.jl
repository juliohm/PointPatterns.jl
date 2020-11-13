# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    UnionProcess(p₁, p₂)

Union (or superposition) of spatial point processes `p₁` and `p₂`.
"""
struct UnionProcess{P₁<:PointProcess,P₂<:PointProcess} <: PointProcess
  p₁::P₁
  p₂::P₂
end

ishomogeneous(p::UnionProcess) = ishomogeneous(p.p₁) && ishomogeneous(p.p₂)

struct UnionSampling end

default_sampling_algorithm(::UnionProcess) = UnionSampling()

function rand_single(p::UnionProcess, r::AbstractGeometry, algo::UnionSampling)
  pp₁ = rand(p.p₁, r)
  pp₂ = rand(p.p₂, r)

  X = coordinates(pp₁)
  Y = coordinates(pp₂)

  PointPattern(hcat(X, Y))
end
