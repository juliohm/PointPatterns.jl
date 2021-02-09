using PointPatterns
using GeoStatsBase
using Test, Random

# list of tests
testfiles = [
  "processes.jl"
]

@testset "PointPatterns.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
