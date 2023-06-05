@testset "Thinning" begin
  @testset "PointSet" begin
    p = PoissonProcess(10)
    q = Quadrangle((0.0, 0.0), (4.0, 0.0), (4.0, 4.0), (0.0, 4.0))
    pp = rand(p, q)
    tp = thin(pp, RandomThinning(0.3))
    @test length(tp) ≤ length(pp)
    xs = coordinates.(tp)
    @test all(0 .≤ first.(xs) .≤ 4.0)
    @test all(0 .≤ last.(xs) .≤ 4.0)

    λ(s::Point2) = sum(coordinates(s) .^ 2)
    tp = thin(pp, RandomThinning(s -> λ(s) / λ(Point(4.0, 4.0))))
    @test length(tp) ≤ length(pp)
    xs = coordinates.(tp)
    @test all(0 .≤ first.(xs) .≤ 4.0)
    @test all(0 .≤ last.(xs) .≤ 4.0)
  end
end
