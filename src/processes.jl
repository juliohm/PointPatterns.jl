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
inside geometry or domain `g`. Optionally specify sampling
algorithm `algo` and random number generator `rng`.
"""
Base.rand(rng::Random.AbstractRNG, p::PointProcess, g, n::Int; algo=default_sampling_algorithm(p, g)) =
  [rand_single(rng, p, g, algo) for i in 1:n]

Base.rand(rng::Random.AbstractRNG, p::PointProcess, g; algo=default_sampling_algorithm(p, g)) =
  rand_single(rng, p, g, algo)

Base.rand(p::PointProcess, g, n::Int; algo=default_sampling_algorithm(p, g)) =
  rand(Random.GLOBAL_RNG, p, g, n; algo=algo)

Base.rand(p::PointProcess, g; algo=default_sampling_algorithm(p, g)) = rand(Random.GLOBAL_RNG, p, g; algo=algo)

"""
    rand_single(rng, p, g, algo)

Generate a single realization of spatial point process
`p` inside geometry or domain `g` with sampling `algo`.
"""
function rand_single end

"""
    default_sampling_algorithm(p, g)

Default sampling algorithm for spatial point process `p`
on geometry or domain `g`.
"""
function default_sampling_algorithm end

# --------------------
# SAMPLING ALGORITHMS
# --------------------

"""
    ThinnedSampling(λmax)

Generate sample using Lewis-Shedler algorithm (1979) with
maximum real value `λmax` of the intensity function.
"""
struct ThinnedSampling{T<:Real}
  λmax::T
end

"""
    DiscretizedSampling()

Generate sample assuming the intensity is constant over a `Geometry`
or piecewise constant over a `Domain`.
"""
struct DiscretizedSampling end

struct UnionSampling end

#-----------------
# IMPLEMENTATIONS
#-----------------

include("processes/binomial.jl")
include("processes/poisson.jl")
include("processes/union.jl")
