# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
   PoissonProcess(λ)

A Poisson process with intensity `λ`. For a homogeneous process,
define `λ` a constant value, while for an inhomogeneous process,
define `λ` as a function or vector. If `λ` is a vector, it is
assumed that the process is associated with a `Mesh` with the same
number of elements as `λ`.
"""

struct PoissonProcess{L<:Union{Real,Function,Vector}} <: PointProcess
  λ::L
end

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) = PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ)

Base.union(p₁::PoissonProcess{<:Vector}, p₂::PoissonProcess{<:Vector}) = PoissonProcess(x -> p₁.λ + p₂.λ)

ishomogeneous(p::PoissonProcess{<:Real}) = true
ishomogeneous(p::PoissonProcess{<:Function}) = false
ishomogeneous(p::PoissonProcess{<:Vector}) = false

default_sampling_algorithm(::PoissonProcess, ::GeometryOrMesh) = DiscretizedSampling()

#------------------
# HOMOGENEOUS CASE
#------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Real}, g::GeometryOrMesh, ::DiscretizedSampling)
  # simulate number of points
  λ = p.λ
  V = measure(g)
  n = rand(rng, Poisson(λ * V))

  # simulate homogeneous process
  pts = sample(g, HomogeneousSampling(n))

  # return point pattern
  PointSet(collect(pts))
end

#--------------------
# INHOMOGENEOUS CASE
#--------------------

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Vector}, m::Mesh, algo::DiscretizedSampling)
  # simulate number of points
  λ = p.λ
  V = measure.(m)
  n = rand(rng, Poisson(sum(λ .* V)))

  # sample elements with weights proportial to expected number of points
  w = WeightedSampling(n, λ .* V, replace = true)

  # within each element sample a single point
  h = HomogeneousSampling(1)
  pts = (first(sample(rng, e, h)) for e in sample(rng, m, w))

  # return point pattern
  PointSet(collect(pts))
end

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g::Geometry, algo::DiscretizedSampling)
  # discretize region
  g = discretize(g)
  m = centroid.(g)
  λvec = p.λ.(m)

  # sample point pattern
  rand_single(rng, PoissonProcess(λvec), g, DiscretizedSampling())
end

function rand_single(rng::Random.AbstractRNG, p::PoissonProcess{<:Function}, g::GeometryOrMesh, algo::ThinnedSampling)
  # simulate a homogeneous process
  pp = rand(rng, PoissonProcess(algo.λmax), g)

  # thin point pattern
  thin(pp, RandomThinning(x -> p.λ(x) / algo.λmax))
end

