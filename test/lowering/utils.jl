module test_julialowering_utils

# see also julia/doc/src/devdocs/agents/skills/julia-syntax-lowering/SKILL.md

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, parseall, @K_str

src = """
function f()
    xs
end
function g()
    xs
end
"""
ex = parseall(SyntaxTree, src)
@test JS.kind(ex) == K"toplevel"
@test JL._value_string(ex) == """::K\"toplevel\""""
@test sprint(JL._show_syntax_tree_sexpr, ex) == "(toplevel (function (call f) (block xs)) (function (call g) (block xs)))"
@test sprint(JL._show_syntax_tree_sexpr, ex[1]) == "(function (call f) (block xs))"
@test sprint(JL._show_syntax_tree_sexpr, ex[2]) == "(function (call g) (block xs))"

end # module test_julialowering_utils


module test_julialowering_jl_lower

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree

# from julia/JuliaLowering/test/utils.jl

function jl_lower(mod::Module, ex::Expr)
    st = JL.expr_to_est(ex)
    JL.lower(mod, st; expr_compat_mode=false)
end

module Mod
end

ex = :(1 + 2)
x = jl_lower(Mod, ex)
ir = sprint(JL.print_ir, x)

@test x isa SyntaxTree{Dict{Symbol, Dict{Int, Any}}}
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
