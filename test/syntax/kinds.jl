module test_juliasyntax_kinds

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: @K_str, @KSet_str, Kind

k = K"√"
@test k == Kind("√")
@test JS.is_operator(k)
@test K"BEGIN_OPS" <= k <= K"END_OPS"

using .JS: SyntaxNode, parsestmt
t = parsestmt(SyntaxNode, "√")
@test t isa SyntaxNode
@test sprint(show, MIME("text/x.sexpression"), t) == "√"

# from julia/JuliaSyntax/test/parser.jl
using .JS: ParseStream, ParseState, validate_tokens, build_tree,
           Diagnostic, parse_unary # production
stream = ParseStream("√", version=v"1.6")
parse_unary(ParseState(stream))
diagnostics = validate_tokens(stream)
@test diagnostics isa Vector{Diagnostic}
@test isempty(diagnostics)
s = build_tree(SyntaxNode, stream, keep_parens=true)
@test s == t

@test KSet"constdecl" == (K"constdecl",)

end # module test_juliasyntax_kinds
