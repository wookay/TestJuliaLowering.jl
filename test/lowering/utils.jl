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
using .JL: JuliaLowering, SyntaxTree, SyntaxContext, JL_NEW_EDITION
using JuliaSyntax: JuliaSyntax as JS
using .JS: JuliaSyntax, Syntax

# from julia/JuliaLowering/test/utils.jl

function _jl_lower(mod::Module, st::SyntaxTree)
    JuliaLowering.lower(mod, st)
end

function _force_syntax(x, mod, edition::Tuple{Int, Int})
    if x isa SyntaxTree
        JuliaLowering._ensure_edition(x, edition)
    elseif x isa AbstractString
        # note macroexpand/lower aren't particularly useful with parseall
        JuliaSyntax.parseall(SyntaxTree, x; version=VersionNumber(edition), ignore_warnings=true)
    elseif x isa Expr
        JuliaLowering.expr_to_est(x, Base.first_linenode(x),
                                  SyntaxContext(mod, edition))
    else
        error("expected string or AST, got $x")
    end
end

jl_lower(mod::Module, x; edition=JL_NEW_EDITION) =
    _jl_lower(mod, _force_syntax(x, mod, edition))

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
using .JL: JuliaLowering, SyntaxTree

# from julia/JuliaLowering/test/utils.jl

function with_lowering(f, enable::Bool)
    lowerer = Core._lower
    toplevel_eval = Core._toplevel_eval
    world = JuliaLowering._lowering_world[]
    try
        JuliaLowering.activate!(enable)
        f()
    finally
        Core._setlowerer!(lowerer)
        Core._set_toplevel_eval!(toplevel_eval)
        JuliaLowering._lowering_world[] = world
    end
end

with_flisp(f) = with_lowering(f, false)

function fl_lower(mod::Module, x::Expr)
    with_flisp() do
        Base.fl_lower(mod, x, Base.get_world_counter(), false, Base.first_linenode(x))[1]
    end
end

fl_lower(mod::Module, st::SyntaxTree; kws...) =
    fl_lower(mod, JuliaLowering.est_to_expr(st); kws...)

function fl_eval(mod::Module, x::Expr)
    with_flisp() do
        Core.eval(mod, x)
    end
end

fl_eval(mod::Module, code::AbstractString) =
    fl_eval(mod, Meta.parseall(code; filename="string", mod))

fl_eval(mod::Module, st::SyntaxTree; kws...) =
    fl_eval(mod, JuliaLowering.est_to_expr(st); kws...)


module Mod
end

ex = :(1 + 2)
x = fl_lower(Mod, ex)

@test x isa Expr
@test Base.isexpr(x, :thunk)
@test fl_eval(Mod, ex) == 3

end # module test_julialowering_fl_lower
