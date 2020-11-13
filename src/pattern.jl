# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    PointPattern(coords)

A set of points with coordinate matrix `coords`. The number of rows
of the matrix is the dimensionality of the pattern whereas the number
of columns is the number of points in the pattern. Alternatively, `coords`
can be a vector of tuples (i.e. points).
"""
struct PointPattern{T,N}
  coords::Matrix{T}
end

PointPattern(coords::AbstractMatrix{T}) where {T} =
  PointPattern{T,size(coords,1)}(coords)

PointPattern(coords::AbstractVector{NTuple{N,T}}) where {N,T} =
  PointPattern([c[i] for i in 1:N, c in coords])

"""
    npoints(pp)

Return number of points in spatial point pattern `pp`.
"""
npoints(pp::PointPattern) = size(pp.coords, 2)

"""
    coordinates(pp, inds)

Return the coordinates of the points at indices `inds` in
the point pattern `pp`.
"""
coordinates(pp::PointPattern{T,N}, inds) where {N,T} = view(pp.coords, :, inds)

"""
    coordinates(pp)

Return the coordinates of all points in point pattern `pp`.
"""
coordinates(pp::PointPattern) = pp.coords

# ------------
# IO methods
# ------------
function Base.show(io::IO, pp::PointPattern{T,N}) where {N,T}
  npts = size(pp.coords, 2)
  print(io, "$npts PointPattern{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", pp::PointPattern{T,N}) where {N,T}
  println(io, pp)
  Base.print_array(io, pp.coords)
end
