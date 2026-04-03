module ExpandForms # TestJuliaLowering

using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS

# from julia/JuliaLowering/test/demo.jl
function debug_lower(mod::Module, ex::JS.SyntaxTree; expr_compat_mode::Bool=false, verbose::Bool=false, do_eval::Bool=false)
    ctx1, ex_macroexpand = JL.expand_forms_1(mod, ex, expr_compat_mode, Base.get_world_counter())
    ctx2, ex_desugar = JL.expand_forms_2(ctx1, ex_macroexpand)
    #      (ctx1, ex_macroexpand, ctx2, ex_desugar, ctx3, ex_scoped, ctx4, ex_converted, ctx5, ex_compiled, ex_expr, eval_result)
    return (ctx1, ex_macroexpand, ctx2, ex_desugar)
end # function debug_lower


# from julia/JuliaLowering/test/scopes.jl
function resolve_and_get_bindings(
        mod::Module, ex::Expr;
        world::UInt = Base.get_world_counter(),
        soft_scope::Union{Nothing,Bool} = nothing,
    )
    est = JL.expr_to_est(ex)
    ctx1, ex1 = JL.expand_forms_1(mod, est, false, world)
    ctx2, ex2 = JL.expand_forms_2(ctx1, ex1)
    ctx3, _ = JL.resolve_scopes(ctx2, ex2; soft_scope)
    return ctx3.bindings.info
end # function resolve_and_get_bindings

end # module TestJuliaLowering.ExpandForms
