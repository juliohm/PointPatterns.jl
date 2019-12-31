# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    PointProcess

A spatial point process.
"""
abstract type PointProcess end

"""
    rand(p, r, n=1)

Generate `n` realizations of spatial point process `p`
inside spatial region `r`.
"""
Base.rand(p::PointProcess, r::AbstractRegion, n::Int=1) =
  [rand_single(p, r) for i in 1:n]

#-----------------
# IMPLEMENTATIONS
#-----------------
include("processes/binomial.jl")
