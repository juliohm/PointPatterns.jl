# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonProcess(λ)

A Poisson process with intensity `λ`.
"""
struct PoissonProcess{L} <: PointProcess
  λ::L
end

function rand_single(p::PoissonProcess, r::RectangleRegion{T,N}) where {N,T}
  # region configuration
  lo = lowerleft(r)
  up = upperright(r)

  # simulate number of points
  λ = p.λ
  V = volume(r)
  n = rand(Poisson(λ*V))

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:N])

  # return point pattern
  PointSet(rand(U, n))
end
