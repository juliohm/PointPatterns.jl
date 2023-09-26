import PointPatterns: check_marks, check_region
@testset "Patterns" begin
    
    @testset "check_region" begin
        seg = Segment((0.0, 0.0), (11.3, 11.3))
        tri = Triangle((0.0, 0.0), (5.65, 0.0), (5.65, 5.65))
        quad = Quadrangle((0.0, 0.0), (0.0, 4.0), (4.0, 4.0), (4.0, 0.0))
        box = Box((0.0, 0.0), (4.0, 4.0))
        ball = Ball((1.0, 1.0), 2.25)
        outer = [(0, -4), (4, -1), (4, 1.5), (0, 3)]
        hole1 = [(0.2, -0.2), (1.4, -0.2), (1.4, 0.6), (0.2, 0.6)]
        hole2 = [(2, -0.2), (3, -0.2), (3, 0.4), (2, 0.4)]
        poly = PolyArea([outer, hole1, hole2])
        regions = [seg, tri, quad, box, ball, poly]
        points = PointSet([(100,100)])
        for r in regions
            @test_throws AssertionError check_region(points, r)
        end
    end

    @testset "check_marks" begin
        points = PointSet([(0,1), (0,3), (0,5), (0,7), (0,9)])
        @test isnothing(check_marks(points, [1, 2, 3, 4, 5]))
        @test isnothing(check_marks(points, nothing))
        @test_throws AssertionError check_marks(points, [1, 2, 3, 4])
    end

    @testset "vcat" begin
        region = Box((0,0), (1,10))
        points₁ = PointSet([(0,1), (0,3), (0,5), (0,7), (0,9)])
        marks₁ = [1, 2, 3, 4, 5]
        points₂ = PointSet([(1,1), (1,3), (1,5), (1,7), (1,9)])
        marks₂ = [6, 7, 8, 9, 10]
        
        pp₁ = PointPattern(points₁, region, marks₁)
        pp₂ = PointPattern(points₂, region, marks₂)
        pp₃ = PointPattern(points₁, region, nothing)
        pp₄ = PointPattern(points₂, region, nothing)
        pp₅ = PointPattern(points₂, Box((0,0), (1,11)), marks₂)

        pp₁₂ = vcat(pp₁, pp₂)
        pp₃₄ = vcat(pp₃, pp₄)
        @test pp₁₂.points == PointSet(vcat(parent(points₁), parent(points₂)))
        @test pp₁₂.marks == vcat(marks₁, marks₂)
        @test pp₁₂.region == pp₁.region
        @test pp₃₄.points == PointSet(vcat(parent(points₁), parent(points₂)))
        @test isnothing(pp₃₄.marks)
        @test pp₃₄.region == pp₃.region

        @test_throws ArgumentError vcat(pp₁, pp₃)
        @test_throws ArgumentError vcat(pp₂, pp₄)
        @test_throws ArgumentError vcat(pp₁, pp₅)

        @test length(pp₁) == 5
        @test PointPatterns.nelements(pp₁) == 5
    end
end