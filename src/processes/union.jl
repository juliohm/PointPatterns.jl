# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    UnionProcess(p₁, p₂)

Union (or superposition) of spatial point processes `p₁` and `p₂`.
"""
struct UnionProcess{P₁<:PointProcess,P₂<:PointProcess} <: PointProcess
  p₁::P₁
  p₂::P₂
end

ishomogeneous(p::UnionProcess) = ishomogeneous(p.p₁) && ishomogeneous(p.p₂)

function randsingle(rng::Random.AbstractRNG, p::UnionProcess, g)
  pp₁ = rand(rng, p.p₁, g)
  pp₂ = rand(rng, p.p₂, g)
  PointSet([collect(pp₁); collect(pp₂)])
end

# ----------
# OPERATION
# ----------

"""
    p₁ ∪ p₂

Return the union of point processes `p₁` and `p₂`.
"""
Base.union(p₁::PointProcess, p₂::PointProcess) = UnionProcess(p₁, p₂)

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Real}) = PoissonProcess(p₁.λ + p₂.λ)

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Real}, p₂::PoissonProcess{<:Function}) = PoissonProcess(x -> p₁.λ + p₂.λ(x))

Base.union(p₁::PoissonProcess{<:Function}, p₂::PoissonProcess{<:Real}) = PoissonProcess(x -> p₁.λ(x) + p₂.λ)

Base.union(p₁::PoissonProcess{<:AbstractVector}, p₂::PoissonProcess{<:AbstractVector}) =
  PoissonProcess(x -> p₁.λ + p₂.λ)
