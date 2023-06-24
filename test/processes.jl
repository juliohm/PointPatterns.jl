@testset "Processes" begin
  # geometries and domains
  seg = Segment((0.0, 0.0), (11.3, 11.3))
  tri = Triangle((0.0, 0.0), (5.65, 0.0), (5.65, 5.65))
  quad = Quadrangle((0.0, 0.0), (0.0, 4.0), (4.0, 4.0), (4.0, 0.0))
  box = Box((0.0, 0.0), (4.0, 4.0))
  ball = Ball((1.0, 1.0), 2.25)
  outer = [(0, -4), (4, -1), (4, 1.5), (0, 3)]
  hole1 = [(0.2, -0.2), (1.4, -0.2), (1.4, 0.6), (0.2, 0.6)]
  hole2 = [(2, -0.2), (3, -0.2), (3, 0.4), (2, 0.4)]
  poly = PolyArea(outer, [hole1, hole2])
  grid = CartesianGrid((0, 0), (4, 4), dims=(10, 10))
  points = Point2[(0, 0), (4.5, 0), (0, 4.2), (4, 4.3), (1.5, 1.5)]
  connec = connect.([(1, 2, 5), (2, 4, 5), (4, 3, 5), (3, 1, 5)], Triangle)
  mesh = SimpleMesh(points, connec)
  geoms = [seg, tri, quad, box, ball, poly, grid, mesh]

  # point processes
  λ(s) = sum(coordinates(s) .^ 2)
  binom = BinomialProcess(100)
  poisson1 = PoissonProcess(100.0)
  poisson2 = PoissonProcess(λ)
  inhibit = InhibitionProcess(0.1)
  procs = [binom, poisson1, poisson2, inhibit]

  @testset "Basic" begin
    for p in procs, g in geoms
      pp = rand(p, g)
      @test all(∈(g), pp)
    end
  end

  @testset "Binomial" begin
    p = BinomialProcess(10)
    for g in geoms
      pp = rand(p, g)
      @test nelements(pp) == 10
    end
  end

  @testset "Poisson" begin
    # inhomogeneous with piecewise constant intensity
    for g in [grid, mesh]
      p = PoissonProcess(λ.(centroid.(g)))
      pp = rand(p, g)
      @test all(∈(g), pp)
    end

    # empty pointsets
    for g in geoms
      @test isnothing(rand(PoissonProcess(0.0), seg))
    end

    pp = PointSet(rand(Point2, 10))
    @test isnothing(rand(PoissonProcess(100.0), pp))
  end

  @testset "Inhibition" begin end

  @testset "Cluster" begin end

  @testset "Union" begin
    b = Box((0.0, 0.0), (100.0, 100.0))
    p₁ = BinomialProcess(50)
    p₂ = BinomialProcess(50)
    p = p₁ ∪ p₂ # 100 points

    s = rand(p, b, 2)
    @test length(s) == 2
    @test s[1] isa PointSet
    @test s[2] isa PointSet
    @test nelements.(s) == [100, 100]
  end
end
