# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
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
    rand(p, r, n=1; [algo])

Generate `n` realizations of spatial point process `p`
inside spatial region `r`. Optionally specify sampling
algorithm `algo`.
"""
Base.rand(p::PointProcess, r::AbstractGeometry, n::Int;
          algo=default_sampling_algorithm(p)) =
  [rand_single(p, r, algo) for i in 1:n]

Base.rand(p::PointProcess, r::AbstractGeometry;
          algo=default_sampling_algorithm(p)) =
  rand_single(p, r, algo)

"""
    rand_single(p, r, algo)

Generate a single realization of spatial point process
`p` inside spatial region `r` with sampling `algo`.
"""
rand_single(p::PointProcess, r::AbstractGeometry, algo) =
  @error "not implemented"

"""
    default_sampling_algorithm(p)

Default sampling algorithm for spatial point process `p`.
"""
default_sampling_algorithm(p::PointProcess) = @error "not implemented"

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