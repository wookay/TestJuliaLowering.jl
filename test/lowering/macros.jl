module test_julialowering_macros

using Test
using JuliaLowering: JuliaLowering as JL

# from julia/JuliaLowering/test/macros.jl

macro mac_called_in_do_expression(dofunc, arg)
    :($dofunc($arg))
end

@test @mac_called_in_do_expression(9) do x
    x * 10
end == 90

test_mod = @__MODULE__
# julia commit aa83c3cdb0
if hasmethod(JL.methods_in_world, (Any, Any, Any, Any))
    if VERSION >= v"1.14-DEV"
        @test JL.include_string(test_mod, raw"""
        @mac_called_in_do_expression(9) do x
            x * 10
        end
        """) == 90
    end
else
    @test_throws JL.MacroExpansionError JL.include_string(test_mod, raw"""
    @mac_called_in_do_expression(9) do x
        x * 10
    end
    """)
end # if

end # module test_julialowering_macros
