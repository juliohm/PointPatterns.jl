@testset "Processes" begin
  @testset "Basic" begin
    for p in [BinomialProcess(100), PoissonProcess(100.)]
      r = Box((0.,1.), (1.,2.))
      pp = rand(p, r)
      xs = [coordinates(pp[i]) for i in 1:nelements(pp)]
      @test all(0 .≤ first.(xs) .≤ 1)
      @test all(1 .≤ last.(xs) .≤ 2)
    end
  end

  @testset "Binomial" begin
    # TODO
  end

  @testset "Poisson" begin
    # TODO
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
