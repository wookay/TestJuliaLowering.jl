module test_julialowering_lowering_error

using Test

# code from julia/test/syntax.jl
macro test_loweringerror(ex, msg, opt=nothing)
    code = :(@test Meta.lower(@__MODULE__, $(esc(ex))) == Expr(:error, $msg))
    code.args[2] = __source__
    if opt === :broken
        code.args[1] = :var"@test_broken"
    end
    code
end

@test_loweringerror(Meta.parse("x..."), "\"...\" expression outside call")

end # module test_julialowering_lowering_error
