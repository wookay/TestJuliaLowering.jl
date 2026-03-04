using Jive
@If VERSION >= v"1.14.0-DEV.1303" module test_juliasyntax_expr

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxNode, parsestmt
using Base.Experimental: @VERSION, @set_syntax_version

# from julia/JuliaSyntax/test/expr.jl

n13 = parsestmt(SyntaxNode, "module A end"; version=v"1.13")
n14 = parsestmt(SyntaxNode, "module A end"; version=v"1.14")

@test n13.children[1].data.val == :A
@test n14.children[1].data.val == v"1.14.0"
@test n14.children[2].data.val == :A


function module_version(m::Module)
    include_string(m, "Base.Experimental.@VERSION")
end # function module_version

# from julia/base/experimental.jl
module ChangeSyntax

using Test
using Base.Experimental: @VERSION
(; syntax, runtime) = @VERSION
@test syntax >= v"1.14"

using Base.Experimental: @set_syntax_version
@set_syntax_version v"1.13"

using ..test_juliasyntax_expr: module_version
@test module_version(@__MODULE__).syntax == v"1.13"

end # module ChangeSyntax

@test module_version(ChangeSyntax).syntax == v"1.13"


ex = Base.parse_input_line("using Jive", mod = Main)
@test ex isa Expr

@test (:lno, :syntax_ver) == fieldnames(Core.MacroSource)

end # module test_juliasyntax_expr
