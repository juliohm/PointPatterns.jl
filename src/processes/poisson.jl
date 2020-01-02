# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonProcess(λ)

A Poisson process with intensity `λ`.
"""
struct PoissonProcess{L<:Union{Real,Function}} <: PointProcess
  λ::L
end

ishomogeneous(p::PoissonProcess{<:Real}) = true

# homogeneous case
function rand_single(p::PoissonProcess{<:Real}, r::RectangleRegion{T,N}) where {N,T}
  # region configuration
  lo = lowerleft(r)
  up = upperright(r)

  # simulate number of points
  λ = p.λ; V = volume(r)
  n = rand(Poisson(λ*V))

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:N])

  # return point pattern
  PointPattern(rand(U, n))
end

# inhomogeneous case
function rand_single(p::PoissonProcess{<:Function}, r::RectangleRegion{T,N}) where {N,T}
  # TODO
end

Base.union(p₁::PoissonProcess, p₂::PoissonProcess) = PoissonProcess(p₁.λ + p₂.λ)
