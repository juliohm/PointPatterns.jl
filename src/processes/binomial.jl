# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    BinomialProcess(n)

A Binomial point process with `n` points.
"""
struct BinomialProcess <: PointProcess
  n::Int
end

ishomogeneous(p::BinomialProcess) = true

default_sampling_algorithm(::BinomialProcess) = DiscretizedSampling()

function rand_single(rng::Random.AbstractRNG, p::BinomialProcess, g, ::DiscretizedSampling)
  pts = sample(g, HomogeneousSampling(p.n))
  PointSet(collect(pts))
end
