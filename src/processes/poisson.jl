# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonProcess(λ)

A Poisson process with intensity `λ`. For a homogeneous process,
define `λ` as a constant real value, while for an inhomogeneous process,
define `λ` as a function or vector of values. If `λ` is a vector, it is
assumed that the process is associated with a `Domain` with the same
number of elements as `λ`.
"""
struct PoissonProcess{L<:Union{Real,Function,AbstractVector}} <: PointProcess
  λ::L
end

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) = PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ)

Base.union(p₁::PoissonProcess{<:AbstractVector}, p₂::PoissonProcess{<:AbstractVector}) =
  PoissonProcess(x -> p₁.λ + p₂.λ)

ishomogeneous(p::PoissonProcess{<:Real}) = true

ishomogeneous(p::PoissonProcess{<:Function}) = false

ishomogeneous(p::PoissonProcess{<:AbstractVector}) = false

default_sampling_algorithm(::PoissonProcess, ::Any) = DiscretizedSampling()

default_sampling_algorithm(p::PoissonProcess{<:Function}, g) = ThinnedSampling(default_lambda_max(p, g))

function default_lambda_max(p::PoissonProcess{<:Function}, g)
  points = sample(g, HomogeneousSampling(10000))
  λvec = p.λ.(points)
  maximum(λvec) + 0.05 * (maximum(λvec) - minimum(λvec))
end

#------------------
# HOMOGENEOUS CASE
#------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Real}, g, ::DiscretizedSampling)
  # simulate number of points
  λ = p.λ
  V = measure(g)
  n = rand(rng, Poisson(λ * V))

  if iszero(n)
    nothing
  else
    # simulate homogeneous process
    points = sample(g, HomogeneousSampling(n))

    # return point pattern
    PointSet(points)
  end
end

#--------------------
# INHOMOGENEOUS CASE
#--------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g, algo::ThinnedSampling)
  # simulate a homogeneous process
  pp = rand_single(rng, PoissonProcess(algo.λmax), g, DiscretizedSampling())

  # thin point pattern
  thin(pp, RandomThinning(x -> p.λ(x) / algo.λmax))
end

rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, d::Domain, algo::DiscretizedSampling) =
  rand_single(rng, PoissonProcess(p.λ.(centroid.(d))), d, algo)

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:AbstractVector}, d::Domain, algo::DiscretizedSampling)
  # simulate number of points
  λ = p.λ
  V = measure.(d)
  n = rand(rng, Poisson(sum(λ .* V)))

  # simulate n points
  if iszero(n)
    nothing
  else
    # sample elements with weights proportial to expected number of points
    w = WeightedSampling(n, λ .* V, replace=true)

    # within each element sample a single point
    sampler = HomogeneousSampling(1)
    points = (first(sample(rng, e, sampler)) for e in sample(rng, d, w))

    # return point pattern
    PointSet(points)
  end
end
