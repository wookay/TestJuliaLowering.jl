using Jive
@If VERSION >= v"1.14.0-DEV.1579" module test_juliasyntax_unalias_nodes

using Test
using JuliaSyntax: JuliaSyntax as JS

JS.unalias_nodes

# from julia/JuliaSyntax/test/syntax_graph.jl

end # module test_juliasyntax_unalias_nodes
