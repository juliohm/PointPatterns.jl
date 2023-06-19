@testset "Processes" begin
  seg = Segment((0.0,0.0), (11.3,11.3))
  tri = Triangle((0.0, 0.0), (5.65, 0.0), (5.65, 5.65))
  quad = Quadrangle((0.0,0.0), (0.0,4.0), (4.0, 4.0), (4.0, 0.0))
  box = Box((0.0,0.0), (4.0, 4.0))
  ball = Ball((1.0,1.0), 2.25)
  outer = Point2[(0,-4),(4,-1),(4,1.5),(0,3)]
  hole1 = Point2[(0.2,-0.2),(1.4,-0.2),(1.4,0.6),(0.2,0.6)]
  hole2 = Point2[(2,-0.2),(3,-0.2),(3,0.4),(2,0.4)]
  poly = PolyArea(outer, [hole1, hole2])
  grid = CartesianGrid((0,0), (4,4), dims = (10, 10))
  points = Point2[(0, 0), (4.5, 0), (0, 4.2), (4, 4.3), (1.5, 1.5)]
  connec = connect.([(1, 2, 5), (2, 4, 5), (4, 3, 5), (3, 1, 5)], Triangle)
  mesh = SimpleMesh(points, connec)

  @testset "Basic" begin
    for p in [BinomialProcess(100), PoissonProcess(100.0)]
      b = Box((0.0, 1.0), (1.0, 2.0))
      pp = rand(p, b)
      xs = coordinates.(pp)
      @test all(0 .≤ first.(xs) .≤ 1)
      @test all(1 .≤ last.(xs) .≤ 2)
    end
  end

  @testset "Binomial" begin
    p = BinomialProcess(10)
    for g in [seg, tri, quad, box, ball, poly, grid, mesh]
      pp = rand(p, g)
      @test nelements(pp) == 10
      @test all(∈(g), pp)
    end
  end

  @testset "Poisson" begin
    # homogeneous
    p = PoissonProcess(10.0)
    for g in [seg, tri, quad, box, ball, poly, grid, mesh]
      pp = rand(p, g)
      @test all(∈(g), pp)
    end

    # inhomogeneous with intensity function
    λ(s::Point2) = sum(coordinates(s) .^ 2)
    p = PoissonProcess(λ)
    for g in [seg, tri, quad, box, ball, poly, grid, mesh]
      # default thinnedsampling
      pp = rand(p, g)
      @test all(∈(g), pp)
      # custom thinnedsampling using λmax
      pp = rand(p, g, algo = ThinnedSampling(λ(Point2(12.0, 12.0))))
      @test all(∈(g), pp)
      # discretizedsampling
      g = discretize(g)
      pp = rand(p, g, algo = DiscretizedSampling())
      @test all(∈(g), g)
    end

    # inhomogeneous with piecewise constant intensity
    for g in [grid, mesh]
      λ(s::Point2) = sum(coordinates(s) .^ 2)
      λvec = λ.(centroid.(g))
      p = PoissonProcess(λvec)
      # discretizedsampling
      pp = rand(p, g)
      @test all(∈(g), pp)
    end

    # empty pointsets
    for g in [seg, tri, quad, box, ball, poly, grid, mesh]
      @test isnothing(rand(PoissonProcess(0.0), seg))
    end
    ps = PointSet(rand(Point2, 10))
    @test isnothing(rand(PoissonProcess(100.0), ps))
  end

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
