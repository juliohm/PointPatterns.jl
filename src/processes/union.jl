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

function rand_single(p::UnionProcess, g::Geometry, algo::UnionSampling)
  pp₁ = rand(p.p₁, g)
  pp₂ = rand(p.p₂, g)

  X = [coordinates(pp₁[i]) for i in 1:nelements(pp₁)]
  Y = [coordinates(pp₂[i]) for i in 1:nelements(pp₂)]

  PointSet([X; Y])
end
