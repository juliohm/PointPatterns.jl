"""
    PointPattern(points, region, marks)
    PointPattern(points, region)
    
Constructs a point pattern with the `points::PointSet` and `region::Geometry`. 
If `marks` are provided, they must be an `AbstractVector` of the same length as points. 
If `marks` are not provided or are `nothing`, the point pattern is unmarked.
"""
struct PointPattern{T,D,G,M}
  points::PointSet{T,D}
  region::G
  marks::M
  function PointPattern(points::PointSet{T,D}, region::G, marks::M) where {T,D,G<:Meshes.GeometryOrDomain,M}
    check_marks(points, marks)
    check_region(points, region)
    new{T,D,G,M}(points, region, marks)
  end
  function PointPattern(points::PointSet{T,D}, region::G) where {T,D,G<:Meshes.GeometryOrDomain}
    PointPattern(points, region, nothing)
  end
end

"""
    check_region(points, region)

Checks that all points are contained in the region.
"""
function check_region(points::PointSet, region)
  @assert embeddim(points) == embeddim(region)
  @assert all(∈(region), points)
  nothing
end


"""
    check_marks(points::PointSet{T,D}, marks) where {T,D,M}

Checks that the marks are `nothing` if the points are unmarked or an `AbstractVector` of the same length as points if marks are provided.
"""
check_marks(points::PointSet{T,D}, marks::Nothing) where {T,D} = nothing
function check_marks(points::PointSet{T,D}, marks::AbstractVector{M}) where {T,D,M}
  @assert length(points) == length(marks)
  nothing
end
function Base.vcat(pp₁::PointPattern, pp₂::PointPattern)
  pp₁.region == pp₂.region || throw(ArgumentError("Point patterns must have the same region."))
  points = PointSet(vcat(collect(pp₁.points), collect(pp₂.points)))
  marks = join_marks(pp₁.marks, pp₂.marks)
  PointPattern(points, pp₁.region, marks)
end

"""
    join_marks(marks₁, marks₂)

Concatenate two collections of marks. Will error if exactly one of the processes is marked.
"""
join_marks(marks₁::Nothing, marks₂::Nothing) = nothing
join_marks(marks₁::AbstractArray, marks₂::AbstractArray) = vcat(marks₁, marks₂)
join_marks(::Nothing, ::AbstractArray) =
  throw(ArgumentError("Cannot concatenate marked and unmarked point patterns."))
join_marks(::AbstractArray, ::Nothing) =
  throw(ArgumentError("Cannot concatenate marked and unmarked point patterns."))

Meshes.nelements(pp::PointPattern) = nelements(pp.points)
Base.length(pp::PointPattern) = nelements(pp)