@testset "Processes" begin
  @testset "Basic" begin
    for p in [BinomialProcess(100), PoissonProcess(100.)]
      r = Rectangle((0.,1.), (1.,1.))
      P = rand(p, r)
      X = coordinates(P)
      @test all(0 .≤ X[1,:] .≤ 1)
      @test all(1 .≤ X[2,:] .≤ 2)
    end
  end

  @testset "Binomial" begin
    # TODO
  end

  @testset "Poisson" begin
    # TODO
  end
end
