using Jive
@useinside Main module test_juliasyntax_expr
# @If VERSION >= v"1.14.0-DEV.1303" module test_juliasyntax_expr

using Test
using JuliaSyntax: SyntaxNode, parsestmt
using Base.Experimental: @VERSION, @set_syntax_version

# from julia/JuliaSyntax/test/expr.jl

n13 = parsestmt(SyntaxNode, "module A end"; version=v"1.13")
n14 = parsestmt(SyntaxNode, "module A end"; version=v"1.14")

@test n13.children[1].data.val == :A
@test n14.children[1].data.val == v"1.14.0"
@test n14.children[2].data.val == :A


# from julia/base/experimental.jl

@set_syntax_version v"1.13"
module ChangeSyntax

using Test: @test
using Base.Experimental: @VERSION, @set_syntax_version

@test (@VERSION) isa @NamedTuple{syntax::VersionNumber, runtime::VersionNumber}
(; syntax, runtime) = @VERSION
@test syntax == v"1.13"
@test runtime == VERSION

const age1 = Base.get_world_counter()
@set_syntax_version v"1.14"
const age2 = Base.get_world_counter()
@test age1 != age2

# syntax == v"1.13"

end # module ChangeSyntax


(; syntax, runtime) = @VERSION
@test runtime == VERSION

ex = Base.parse_input_line("using Jive", mod = Main)
@test ex isa Expr

@test (:lno, :syntax_ver) == fieldnames(Core.MacroSource)

end # module test_juliasyntax_expr
