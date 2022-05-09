@testset "Processes" begin
  @testset "Basic" begin
    for p in [BinomialProcess(100), PoissonProcess(100.)]
      b  = Box((0.,1.), (1.,2.))
      pp = rand(p, b)
      xs = coordinates.(pp)
      @test all(0 .≤ first.(xs) .≤ 1)
      @test all(1 .≤ last.(xs) .≤ 2)
    end
  end

  @testset "Binomial" begin
    # TODO
  end

  @testset "Poisson" begin
    p = PoissonProcess(100.)
    t = Triangle((0.,0.), (1.,0.), (1.,1.))
    pp = rand(p, t)
    xs = coordinates.(pp)
    @test all(0 .≤ first.(xs) .≤ 1)
    @test all(0 .≤ last.(xs))

    q = Quadrangle((0.,0.), (1.,0.), (1.,1.), (0.,1.))
    pp = rand(p, q)
    xs = coordinates.(pp)
    @test all(0 .≤ first.(xs) .≤ 1)
    @test all(0 .≤ last.(xs) .≤ 1)
  end

  @testset "Union" begin
    b  = Box((0.,0.), (100.,100.))
    p₁ = BinomialProcess(50)
    p₂ = BinomialProcess(50)
    p  = p₁ ∪ p₂ # 100 points

    s = rand(p, b, 2)
    @test length(s) == 2
    @test s[1] isa PointSet
    @test s[2] isa PointSet
    @test nelements.(s) == [100,100]
  end
end
