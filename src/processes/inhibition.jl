# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    InhibitionProcess(r)

An inhibition point process with radius `r`.
"""
struct InhibitionProcess{R<:Real} <: PointProcess
  r::R
end

randsingle(rng::Random.AbstractRNG, p::InhibitionProcess, g) = PointSet(sample(rng, g, MinDistanceSampling(p.r)))
