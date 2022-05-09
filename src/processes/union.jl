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

function rand_single(rng::Random.AbstractRNG,
                     p::UnionProcess, g::Geometry,
                     ::UnionSampling)
  pp₁ = rand(rng, p.p₁, g)
  pp₂ = rand(rng, p.p₂, g)

  PointSet([coordinates.(pp₁); coordinates.(pp₂)])
end
