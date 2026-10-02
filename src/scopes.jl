module Scopes # TestJuliaLowering

using JuliaLowering: JuliaLowering, JuliaSyntax, JL_NEW_EDITION

# from julia/JuliaLowering/test/scopes.jl
function resolve_and_get_bindings(
        mod::Module, ex;
        world::UInt = Base.get_world_counter(),
        soft_scope::Union{Nothing,Bool} = nothing,
        edition = JL_NEW_EDITION,
    )
    est = JuliaLowering.expr_to_est(ex, LineNumberNode(1),
                                    JuliaSyntax.SyntaxContext(mod, edition))
    ex0 = JuliaLowering.rebase_layers(est, mod)
    ex1 = JuliaLowering.expand_forms_1(ex0, world, true)
    ctx2, ex2 = JuliaLowering.expand_forms_2(ex1, world)
    ctx3, _ = JuliaLowering.resolve_scopes(ctx2, ex2; soft_scope)
    return ctx3.bindings.info
end

end # module TestJuliaLowering.Scopes
