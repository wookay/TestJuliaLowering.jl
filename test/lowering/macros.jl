module test_julialowering_macros

using Test
using JuliaLowering: JuliaLowering

# from julia/JuliaLowering/test/macros.jl

test_mod = Module(:macro_test)

@testset "old macros producing exotic expr heads" begin
    test_result = JuliaLowering.include_string(test_mod, """
    using Test
    @test identity(123) === 123
    """; expr_compat_mode=true)
    @test test_result.value === true

    # @testset produces :tryfinally with secret third arg
    @eval test_mod :(using Test)
    @test JuliaLowering.include_string(test_mod, "@test true") isa Test.Pass
    @testset let jltestset = JuliaLowering.include_string(test_mod, """
    @testset begin
        @test true
    end
    """; expr_compat_mode=true)
        @test jltestset isa Test.AbstractTestSet
        @test jltestset.n_passed == 1
    end
end

end # module test_julialowering_macros
