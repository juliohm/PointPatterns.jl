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

struct BinomialSampling end

default_sampling_algorithm(::BinomialProcess) = BinomialSampling()

function rand_single(p::BinomialProcess, b::Box{Dim,T},
                     ::BinomialSampling) where {Dim,T}
  # region configuration
  lo, up = coordinates.(extrema(b))

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:Dim])

  # return point pattern
  PointSet(rand(U, p.n))
end
