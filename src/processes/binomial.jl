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

randsingle(rng::Random.AbstractRNG, p::BinomialProcess, g) =
  PointSet(sample(rng, g, HomogeneousSampling(p.n)))
