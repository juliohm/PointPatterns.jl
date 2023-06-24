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
    rand([rng], p, g, n=1)

Generate `n` realizations of spatial point process `p`
inside geometry or domain `g`. Optionally specify the
random number generator `rng`.
"""
Base.rand(rng::Random.AbstractRNG, p::PointProcess, g, n::Int) = [randsingle(rng, p, g) for _ in 1:n]

Base.rand(rng::Random.AbstractRNG, p::PointProcess, g) = randsingle(rng, p, g)

Base.rand(p::PointProcess, g, n::Int) = rand(Random.GLOBAL_RNG, p, g, n)

Base.rand(p::PointProcess, g) = rand(Random.GLOBAL_RNG, p, g)

"""
    randsingle(rng, p, g)

Generate a single point pattern of point process `p`
inside geometry or domain `g`.
"""
function randsingle end

#-----------------
# IMPLEMENTATIONS
#-----------------

include("processes/binomial.jl")
include("processes/poisson.jl")
include("processes/cluster.jl")
include("processes/union.jl")
