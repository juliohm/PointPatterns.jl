# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    AbstractThinning

A method for thinning spatial point processes and patterns.
"""
abstract type AbstractThinning end

"""
    thin(p, t)

Thin spatial point process `p` with thinning method `t`.
"""
thin(p::PointProcess, t::AbstractThinning) = @error "not implemented"

#-----------------
# IMPLEMENTATIONS
#-----------------
include("thinning/random.jl")
