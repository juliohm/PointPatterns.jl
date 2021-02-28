# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
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

"""
    thin(pp, t)

Thin spatial point pattern `pp` with thinning method `t`.
"""
thin(pp::PointSet, t::AbstractThinning) = @error "not implemented"

#-----------------
# IMPLEMENTATIONS
#-----------------
include("thinning/random.jl")
