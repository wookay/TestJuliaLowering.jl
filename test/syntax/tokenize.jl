using Jive
@If VERSION >= v"1.14.0-DEV.1282" module test_juliasyntax_tokenize

using Test
using JuliaSyntax: JuliaSyntax
using .JuliaSyntax: @K_str
using .JuliaSyntax.Tokenize: Lexer, RawToken, tokenize

# from julia/JuliaSyntax/test/tokenize.jl
lexer = tokenize("0x1p3.")
@test lexer isa Lexer{IOBuffer}
ts = collect(lexer)
@test ts isa Vector{RawToken}
@test ts[1].kind == K"ErrorInvalidNumericConstant"

end # module test_juliasyntax_tokenize
