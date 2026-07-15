module Scopes # TestJuliaLowering

using JuliaLowering: JuliaLowering

# from julia/JuliaLowering/test/scopes.jl
function resolve_and_get_bindings(
        mod::Module, ex;
        world::UInt = Base.get_world_counter(),
        soft_scope::Union{Nothing,Bool} = nothing,
    )
    est = JuliaLowering.expr_to_est(ex)
    ex0 = JuliaLowering.rebase_layers(est, mod, JuliaLowering.JL_NEW_SYNTAX_VERSION)
    ex1 = JuliaLowering.expand_forms_1(ex0, world, true)
    ctx2, ex2 = JuliaLowering.expand_forms_2(ex1, world)
    ctx3, _ = JuliaLowering.resolve_scopes(ctx2, ex2; soft_scope)
    return ctx3.bindings.info
end

end # module TestJuliaLowering.Scopes
