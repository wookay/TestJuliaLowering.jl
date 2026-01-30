using Jive
@useinside Main module test_julialowering_desugaring
# @If VERSION >= v"1.13.0-DEV.880" module test_julialowering_desugaring

using Test
using JuliaLowering: JuliaLowering
using JuliaSyntax: SyntaxTree, @K_str, parsestmt

# from julia/JuliaLowering/test/demo.jl
function debug_lower(mod::Module, ex::SyntaxTree; expr_compat_mode::Bool=false, verbose::Bool=false, do_eval::Bool=false)
    ctx1, ex_macroexpand = JuliaLowering.expand_forms_1(mod, ex, expr_compat_mode, Base.get_world_counter())
    ctx2, ex_desugar = JuliaLowering.expand_forms_2(ctx1, ex_macroexpand)
    (ctx1, ex_macroexpand, ctx2, ex_desugar)
end # function debug_lower

M = Module(:TestMod)
src = """
using Jive
"""
ex = parsestmt(SyntaxTree, src, filename="foo.jl")
(ctx1, ex_macroexpand, ctx2, ex_desugar) = debug_lower(M, ex; verbose=true, do_eval=true)

@test ex_desugar isa SyntaxTree{Dict{Symbol, Any}}
@test ex_desugar.kind == K"block"

end # module test_julialowering_desugaring
