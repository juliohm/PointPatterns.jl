using PointPatterns
using Meshes
using GeoStatsBase
using Test, Random

# list of tests
testfiles = [
  "processes.jl",
  "thinning.jl"
]

@testset "PointPatterns.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
