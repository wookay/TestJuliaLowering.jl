using Jive
@If VERSION >= v"1.13.0-DEV.880" module test_juliasyntax_syntaxtree

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, parsestmt

src = """
module Foo
end # module Foo
"""
ex = parsestmt(SyntaxTree, src, filename="foo.jl")
@test ex._id isa Int

end # module test_juliasyntax_syntaxtree
