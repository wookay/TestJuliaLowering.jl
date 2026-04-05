using Jive
@If VERSION >= v"1.13.0-DEV.880" module test_julialowering_debug_lower

using Test
using TestJuliaLowering.ExpandForms: debug_lower
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, NodeId, @K_str, parsestmt

M = Module(:TestMod)
src = """
using Jive
"""
ex::SyntaxTree = parsestmt(SyntaxTree, src, filename="foo.jl")
(ctx1, ex_macroexpand, ctx2, ex_desugar) = debug_lower(M, ex; verbose=true, do_eval=true)

@test ex_desugar isa SyntaxTree{Dict{Symbol, Dict{NodeId, Any}}}
@test ex_desugar.kind == K"block"

end # module test_julialowering_debug_lower
