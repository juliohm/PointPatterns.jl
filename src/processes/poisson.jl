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

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) = PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ)

ishomogeneous(p::PoissonProcess{<:Real}) = true
ishomogeneous(p::PoissonProcess{<:Function}) = false

default_sampling_algorithm(::PoissonProcess, ::Geometry) = DiscretizedSampling()

#------------------
# HOMOGENEOUS CASE
#------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Real}, g::Geometry, ::DiscretizedSampling)
  # simulate number of points
  λ = p.λ
  V = measure(g)
  n = rand(rng, Poisson(λ * V))

  # simulate homogeneous process
  pts = sample(g, HomogeneousSampling(n))

  # return point pattern
  PointSet(collect(pts))
end

#--------------------
# INHOMOGENEOUS CASE
#--------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, b::Box, algo::DiscretizedSampling)
  # discretize region
  # TODO

  # discretize retention
  # TODO

  # sample each element
  # TODO
end

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g::Geometry, algo::ThinnedSampling)
  # simulate a homogeneous process
  pp = rand(rng, PoissonProcess(algo.λmax), g)

  # thin point pattern
  thin(pp, RandomThinning(x -> p.λ(x) / algo.λmax))
end
