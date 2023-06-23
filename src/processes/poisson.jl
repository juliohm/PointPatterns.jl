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

defaultalgo(::PoissonProcess, ::Any) = ConstantIntensity()

defaultalgo(p::PoissonProcess{<:Function}, g) = LewisShedler(maxintensity(p, g))

function maxintensity(p::PoissonProcess{<:Function}, g)
  points = sample(g, HomogeneousSampling(10000))
  λmin, λmax = extrema(p.λ, points)
  λmax + 0.05 * (λmax - λmin)
end

#------------------
# HOMOGENEOUS CASE
#------------------

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:Real}, g, ::ConstantIntensity)
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

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g, algo::LewisShedler)
  # simulate a homogeneous process
  pp = randsingle(rng, PoissonProcess(algo.λmax), g, ConstantIntensity())

  # thin point pattern
  isnothing(pp) ? nothing : PointSet(collect(thin(pp, RandomThinning(x -> p.λ(x) / algo.λmax))))
end

randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, d::Domain, algo::ConstantIntensity) =
  randsingle(rng, PoissonProcess(p.λ.(centroid.(d))), d, algo)

function randsingle(rng::Random.AbstractRNG, p::PoissonProcess{<:AbstractVector}, d::Domain, algo::ConstantIntensity)
  # simulate number of points
  λ = p.λ
  V = measure.(d)
  n = rand(rng, Poisson(sum(λ .* V)))

  # simulate n points
  iszero(n) ? nothing : PointSet(sample(rng, d, HomogeneousSampling(n, λ .* V)))
end
