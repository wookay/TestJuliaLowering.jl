module test_julialowering_lowering_error

using Test

# code from julia/test/syntax.jl
macro test_loweringerror1(ex, msg, opt=nothing)
    code = :(@test Meta.lower(@__MODULE__, $(esc(ex))) == Expr(:error, $msg))
    code.args[2] = __source__
    if opt === :broken
        code.args[1] = :var"@test_broken"
    end
end

macro test_loweringerror2(ex, msg, opt=nothing)
    code = :(@test Meta.lower(@__MODULE__, $(esc(ex))) == Expr(:error, $(esc(msg))))
    code.args[2] = __source__
    if opt === :broken
        code.args[1] = :var"@test_broken"
    end
    code
end

@test @macroexpand(@test_loweringerror1(Meta.parse("x..."), "FAFO")) === nothing
@test @macroexpand(@test_loweringerror2(Meta.parse("x..."), "FAFO")) isa Expr

end # module test_julialowering_lowering_error
