using Jive
@useinside Main module test_juliasyntax_expr
# @If VERSION >= v"1.14.0-DEV.1303" module test_juliasyntax_expr

using Test
using JuliaSyntax: SyntaxNode, parsestmt

# from julia/JuliaSyntax/test/expr.jl

n13 = parsestmt(SyntaxNode, "module A end"; version=v"1.13")
n14 = parsestmt(SyntaxNode, "module A end"; version=v"1.14")

@test n13.children[1].data.val == :A
@test n14.children[1].data.val == v"1.14.0"
@test n14.children[2].data.val == :A

end # module test_juliasyntax_expr
