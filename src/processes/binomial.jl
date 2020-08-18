# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    BinomialProcess(n)

A Binomial point process with `n` points.
"""
struct BinomialProcess <: PointProcess
  n::Int
end

ishomogeneous(p::BinomialProcess) = true

struct BinomialSampling end

default_sampling_algorithm(::BinomialProcess) = BinomialSampling()

function rand_single(p::BinomialProcess, r::Rectangle{T,N},
                     algo::BinomialSampling) where {N,T}
  # region configuration
  lo = origin(r)
  up = lo + sides(r)

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:N])

  # return point pattern
  PointPattern(rand(U, p.n))
end
