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
    rand(p, g, n=1; [algo])

Generate `n` realizations of spatial point process `p`
inside geometry `g`. Optionally specify sampling
algorithm `algo`.
"""
Base.rand(p::PointProcess, g::Geometry, n::Int;
          algo=default_sampling_algorithm(p)) =
  [rand_single(p, g, algo) for i in 1:n]

Base.rand(p::PointProcess, g::Geometry;
          algo=default_sampling_algorithm(p)) =
  rand_single(p, g, algo)

"""
    rand_single(p, g, algo)

Generate a single realization of spatial point process
`p` inside geometry `g` with sampling `algo`.
"""
rand_single(::PointProcess, ::Geometry, algo) =
  @error "not implemented"

"""
    default_sampling_algorithm(p)

Default sampling algorithm for spatial point process `p`.
"""
default_sampling_algorithm(::PointProcess) = @error "not implemented"

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
