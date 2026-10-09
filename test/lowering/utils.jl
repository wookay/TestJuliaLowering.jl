module test_julialowering_utils

# see also julia/doc/src/devdocs/agents/skills/julia-syntax-lowering/SKILL.md

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JS: Syntax, parseall, @K_str

src = """
function f()
    xs
end
function g()
    xs
end
"""
ex = parseall(Syntax, src)
@test ex.head === :toplevel

end # module test_julialowering_utils


module test_julialowering_jl_lower

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JS: Syntax

# from julia/JuliaLowering/test/utils.jl

function jl_lower(mod::Module, ex::Expr)
    st = JL.expr_to_est(ex)
    soft_scope::Union{Nothing,Bool} = nothing
    JL.lower(mod, st; soft_scope)
end

module Mod
end

ex = :(1 + 2)
x = jl_lower(Mod, ex)
ir = sprint(JL.print_ir, x)

@test x isa Syntax
@test ir == "1   Main.test_julialowering_jl_lower.Mod.+\n2   (call %₁ 1 2)\n3   (return %₂)\n"

end # module test_julialowering_jl_lower


using Jive
@If VERSION >= v"1.14-DEV" module test_julialowering_fl_lower

using Test
using JuliaLowering: JuliaLowering as JL

# from julia/JuliaLowering/test/utils.jl

function fl_lower(mod::Module, x::Expr)
    Base.fl_lower(x, mod, @__FILE__, @__LINE__, Base.get_world_counter())[1]
end

function fl_eval(mod::Module, x::Expr)
    Core.eval(mod, fl_lower(mod, x))
end

module Mod
end

ex = :(1 + 2)
x = fl_lower(Mod, ex)

@test x isa Expr
@test Base.isexpr(x, :thunk)
@test fl_eval(Mod, ex) == 3

end # module test_julialowering_fl_lower
