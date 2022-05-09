# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonProcess(λ)

A Poisson process with intensity `λ`.
"""
struct PoissonProcess{L<:Union{Real,Function}} <: PointProcess
  λ::L
end

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) =
  PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) =
  PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) =
  PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) =
  PoissonProcess(x -> p₁.λ(x) + p₂.λ)

ishomogeneous(p::PoissonProcess{<:Real}) = true
ishomogeneous(p::PoissonProcess{<:Function}) = false

default_sampling_algorithm(::PoissonProcess, ::Geometry) = DiscretizedSampling()
default_sampling_algorithm(::PoissonProcess{<:Real}, ::Box) = ProductSampling()

#------------------
# HOMOGENEOUS CASE
#------------------

function rand_single(rng::Random.AbstractRNG,
                     p::PoissonProcess{<:Real}, g::Geometry,
                     ::DiscretizedSampling)
  # simulate number of points
  λ = p.λ; V = measure(g)
  n = rand(rng, Poisson(λ*V))

  # simulate homogeneous process
  pts = sample(g, HomogeneousSampling(n))

  # return point pattern
  PointSet(collect(pts))
end

function rand_single(rng::Random.AbstractRNG,
                     p::PoissonProcess{<:Real}, b::Box,
                     ::ProductSampling)
  # region configuration
  lo, up = coordinates.(extrema(b))

  # simulate number of points
  λ = p.λ; V = measure(b)
  n = rand(rng, Poisson(λ*V))

  # product of uniform distributions
  U = product_distribution([Uniform(lo[i], up[i]) for i in 1:embeddim(b)])

  # return point pattern
  PointSet(rand(rng, U, n))
end

#--------------------
# INHOMOGENEOUS CASE
#--------------------

function rand_single(rng::Random.AbstractRNG,
                     p::PoissonProcess{<:Function}, b::Box,
                     algo::DiscretizedSampling)
  # discretize region
  # TODO

  # discretize retention
  # TODO

  # sample each element
  # TODO
end

function rand_single(rng::Random.AbstractRNG,
                     p::PoissonProcess{<:Function}, b::Box,
                     algo::ThinnedSampling)
  # Lewis-Shedler algorithm
  # TODO
end