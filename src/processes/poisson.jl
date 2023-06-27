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

ishomogeneous(p::PoissonProcess{<:Real}) = true

ishomogeneous(p::PoissonProcess{<:Function}) = false

ishomogeneous(p::PoissonProcess{<:AbstractVector}) = false

#------------------
# HOMOGENEOUS CASE
#------------------

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:Real}, g)
  # simulate number of points
  λ = p.λ
  V = measure(g)
  n = rand(rng, Poisson(λ * V))

  # simulate n points
  iszero(n) ? nothing : PointSet(sample(rng, g, HomogeneousSampling(n)))
end

#--------------------
# INHOMOGENEOUS CASE
#--------------------

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g)
  # upper bound for intensity
  λmax = maxintensity(p, g)

  # simulate a homogeneous process
  pset = randsingle(rng, PoissonProcess(λmax), g)

  # thin point pattern
  isnothing(pset) ? nothing : thin(pset, RandomThinning(x -> p.λ(x) / λmax))
end

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:AbstractVector}, d::Domain)
  # simulate number of points
  λ = p.λ .* measure.(d)
  n = rand(rng, Poisson(sum(λ)))

  # simulate point pattern
  iszero(n) ? nothing : PointSet(sample(rng, d, HomogeneousSampling(n, λ)))
end

function maxintensity(p::PoissonProcess{<:Function}, g)
  points = sample(g, HomogeneousSampling(10000))
  λmin, λmax = extrema(p.λ, points)
  λmax + 0.05 * (λmax - λmin)
end
