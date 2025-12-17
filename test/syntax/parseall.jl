using Jive
@useinside Main module test_juliasyntax_parseall
# @If VERSION >= v"1.13.0-DEV.880" module test_juliasyntax_parseall

using Test
using JuliaSyntax: JuliaSyntax

this::String = read(@__FILE__, String)
e::Expr = JuliaSyntax.parseall(Expr, this)

@test e.head === :toplevel
@test e.args[1] == LineNumberNode(1)
@test e.args[2] == :(using Jive)

end # module test_juliasyntax_parseall
