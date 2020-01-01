@testset "Processes" begin
  @testset "Binomial" begin
    p = BinomialProcess(100)
    r = RectangleRegion((0., 1.), (1., 2.))
    P = rand(p, r)
    X = coordinates(P)
    @test all(0 .≤ X[1,:] .≤ 1)
    @test all(1 .≤ X[2,:] .≤ 2)
  end
end
