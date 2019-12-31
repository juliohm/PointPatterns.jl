# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    BinomialProcess(n)

A Binomial point process with `n` points.
"""
struct BinomialProcess <: PointProcess
  npoints::Int
end

function rand_single(p::BinomialProcess, r::RectangleRegion{T,N}) where {N,T}
  # region configuration
  lo = lowerleft(r)
  up = upperright(r)

  # number of points
  n  = p.npoints

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:N])

  # return point pattern
  PointSet(rand(U, n))
end
