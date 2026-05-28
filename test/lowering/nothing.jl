module test_julialowering_nothing

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JL: @K_str

if VERSION >= v"1.14.0-DEV.2040"
    @test K"nothing" isa JS.Kind
end

end # module test_julialowering_nothing
