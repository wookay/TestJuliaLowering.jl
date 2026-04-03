using Jive
@If VERSION >= v"1.14.0-DEV.1579" module test_juliasyntax_unalias_nodes

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, @K_str, NodeId, SyntaxGraph

# from julia/JuliaSyntax/test/syntax_graph.jl

function testgraph(edge_ranges, edges, more_attrs...)
    kinds = Dict{NodeId, Any}(map(i->(i=>K"block"), eachindex(edge_ranges)))
    sources = Dict{NodeId, Any}(
        map(i->(i=>LineNumberNode(i)), eachindex(edge_ranges)))
    orig = Dict{NodeId, Any}(map(i->(i=>i), eachindex(edge_ranges)))
    SyntaxGraph(
        edge_ranges,
        edges,
        Dict{Symbol, Dict{NodeId, Any}}(
            :kind => kinds, :source => sources,
            :orig => orig, more_attrs...))
end

g = testgraph([1:2, 3:3, 4:4, 0:-1], [2, 3, 4, 4])
st = SyntaxTree(g, 1)
stu = JS.unalias_nodes(st)
@test stu isa SyntaxTree{Dict{Symbol, Dict{Int, Any}}}

end # module test_juliasyntax_unalias_nodes
