using Jive
@If VERSION >= v"1.14.0-DEV.1579" module test_juliasyntax_prune

using Test
using JuliaSyntax: JuliaSyntax as JS

JS.prune

# from julia/JuliaSyntax/test/syntax_graph.jl

end # module test_juliasyntax_prune
