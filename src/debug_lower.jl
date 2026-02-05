module DebugLower # TestJuliaLowering

using JuliaLowering: JuliaLowering
using JuliaSyntax: SyntaxTree

# from julia/JuliaLowering/test/demo.jl
function debug_lower(mod::Module, ex::SyntaxTree; expr_compat_mode::Bool=false, verbose::Bool=false, do_eval::Bool=false)
    ctx1, ex_macroexpand = JuliaLowering.expand_forms_1(mod, ex, expr_compat_mode, Base.get_world_counter())
    ctx2, ex_desugar = JuliaLowering.expand_forms_2(ctx1, ex_macroexpand)
    (ctx1, ex_macroexpand, ctx2, ex_desugar)
end # function debug_lower

end # module TestJuliaLowering.DebugLower
