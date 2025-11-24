using Jive
@useinside Main module test_julialowering_desugaring
# @If VERSION >= v"1.13.0-DEV.880" module test_julialowering_desugaring

using Test
using JuliaLowering: JuliaLowering
using .JuliaLowering: SyntaxGraph, SyntaxTree, Bindings, ScopeLayer, parsestmt, syntax_graph
using JuliaSyntax: @K_str

# from julia/JuliaLowering/test/utils.jl
function desugar(mod::Module, src::String)
    ex = parsestmt(SyntaxTree, src, filename="foo.jl")
    expr_compat_mode = true
    ctx = JuliaLowering.DesugaringContext(syntax_graph(ex), Bindings(), ScopeLayer[], mod, expr_compat_mode)
    JuliaLowering.expand_forms_2(ctx, ex)
end

# from julia/JuliaLowering/test/desugaring
test_mod = Module(:TestMod)
st = desugar(test_mod, """
using Jive
""")
@test st isa SyntaxTree{SyntaxGraph{Dict{Symbol, Any}}}
@test st.kind == K"block"

end # module test_julialowering_desugaring
