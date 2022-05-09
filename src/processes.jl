# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    PointProcess

A spatial point process.
"""
abstract type PointProcess end

"""
    ishomogeneous(p)

Tells whether or not the spatial point process `p` is homogeneous.
"""
ishomogeneous(p::PointProcess) = false

"""
    rand([rng], p, g, n=1; [algo])

Generate `n` realizations of spatial point process `p`
inside geometry `g`. Optionally specify sampling
algorithm `algo` and random number generator `rng`.
"""
Base.rand(rng::Random.AbstractRNG,
          p::PointProcess, g::Geometry, n::Int;
          algo=default_sampling_algorithm(p)) =
  [rand_single(rng, p, g, algo) for i in 1:n]

Base.rand(rng::Random.AbstractRNG,
          p::PointProcess, g::Geometry;
          algo=default_sampling_algorithm(p)) =
  rand_single(rng, p, g, algo)

Base.rand(p::PointProcess, g::Geometry, n::Int;
          algo=default_sampling_algorithm(p)) = 
  rand(Random.GLOBAL_RNG, p, g, n; algo=algo)

Base.rand(p::PointProcess, g::Geometry;
          algo=default_sampling_algorithm(p)) = 
  rand(Random.GLOBAL_RNG, p, g; algo=algo)

"""
    rand_single(p, g, algo)

Generate a single realization of spatial point process
`p` inside geometry `g` with sampling `algo`.
"""
rand_single(::Random.AbstractRNG, ::PointProcess, ::Geometry, algo) =
  throw(ErrorException("not implemented"))

"""
    default_sampling_algorithm(p)

Default sampling algorithm for spatial point process `p`.
"""
default_sampling_algorithm(::PointProcess) =
  throw(ErrorException("not implemented"))

"""
    p₁ ∪ p₂

Union (or superposition) of spatial point processes `p₁` and `p₂`.
"""
Base.union(p₁::PointProcess, p₂::PointProcess) = UnionProcess(p₁, p₂)

#-----------------
# IMPLEMENTATIONS
#-----------------
include("processes/binomial.jl")
include("processes/poisson.jl")
include("processes/union.jl")
