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
ishomogeneous(p::PoissonProcess{<:Function}) = false

struct ProductSampling end
struct ThinnedSampling end
struct DiscretizedSampling end

default_sampling_algorithm(::PoissonProcess{<:Real}) = ProductSampling()
default_sampling_algorithm(::PoissonProcess{<:Function}) = DiscretizedSampling()

# -----------------
# homogeneous case
# -----------------
function rand_single(p::PoissonProcess{<:Real}, r::RectangleRegion{T,N},
                     algo::ProductSampling) where {N,T}
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

# -------------------
# inhomogeneous case
# -------------------
function rand_single(p::PoissonProcess{<:Function}, r::RectangleRegion{T,N},
                     algo::DiscretizedSampling) where {N,T}
  # discretize region
  # TODO

  # discretize retention
  # TODO

  # sample each element
  # TODO
end

function rand_single(p::PoissonProcess{<:Function}, r::RectangleRegion{T,N},
                     algo::ThinnedSampling) where {N,T}
  # Lewis-Shedler algorithm
  # TODO
end

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) =
  PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) =
  PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) =
  PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) =
  PoissonProcess(x -> p₁.λ(x) + p₂.λ)
