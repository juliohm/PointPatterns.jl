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
    rand(p, r, n=1)

Generate `n` realizations of spatial point process `p`
inside spatial region `r`.
"""
Base.rand(p::PointProcess, r::AbstractRegion, n::Int) =
  [rand_single(p, r) for i in 1:n]

Base.rand(p::PointProcess, r::AbstractRegion) = rand_single(p, r)

"""
    rand_single(p, r)

Generate a single realization of spatial point process
`p` inside spatial region `r`.
"""
rand_single(p::PointProcess, r::AbstractRegion) = @error "not implemented"

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
