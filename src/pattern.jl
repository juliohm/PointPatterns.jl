# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENSE in the project root.
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

npoints(pp::PointPattern) = size(pp.coords, 2)

"""
    coordinates(pp, ind)

Return the coordinates of the `ind`-th point in the point pattern `pp`.
"""
function coordinates(pp::PointPattern{T,N}, ind::Int) where {N,T}
  x = MVector{N,T}(undef)
  coordinates!(x, pp, ind)
  x
end

"""
    coordinates(pp, inds)

Return the coordinates of the points `inds` in the point pattern `pp`.
"""
function coordinates(pp::PointPattern{T,N}, inds::AbstractVector{Int}) where {N,T}
  X = Matrix{T}(undef, N, length(inds))
  coordinates!(X, pp, inds)
  X
end

"""
    coordinates(pp)

Return the coordinates of all points in point pattern `pp`.
"""
coordinates(pp::PointPattern) = coordinates(pp, 1:npoints(pp))

"""
    coordinates!(buff, pp, inds)

Non-allocating version of [`coordinates`](@ref)
"""
function coordinates!(buff::AbstractMatrix, pp::PointPattern,
                      inds::AbstractVector{Int})
  for j in 1:length(inds)
    coordinates!(view(buff,:,j), pp, inds[j])
  end
end

"""
    coordinates!(buff, pp, ind)

Non-allocating version of [`coordinates`](@ref).
"""
function coordinates!(buff::AbstractVector{T}, pp::PointPattern{T,N},
                      ind::Int) where {N,T}
  for i in 1:N
    @inbounds buff[i] = pp.coords[i,ind]
  end
end

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
