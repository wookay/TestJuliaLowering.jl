using Jive
@If VERSION >= v"1.13.0-DEV.880" module test_julialowering_syntaxtree

using Test
using JuliaLowering: SyntaxTree, parsestmt
using JuliaSyntaxFormatter: JuliaSyntaxFormatter, Text

# from julia/JuliaLowering/test/demo.jl

function formatsrc(ex; kws...)
    Text(JuliaSyntaxFormatter.formatsrc(ex; kws...))
end

src = """
module Foo
end # module Foo
"""
ex = parsestmt(SyntaxTree, src, filename="foo.jl")
@test ex._id <= 10
@test startswith(formatsrc(ex).content, "module ")

end # module test_julialowering_syntaxtree
