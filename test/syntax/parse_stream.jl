using Jive
@useinside Main module test_juliasyntax_parse_stream
# @If VERSION >= v"1.13.0-DEV.880" module test_juliasyntax_parse_stream

using Test
using JuliaSyntax: JuliaSyntax
using .JuliaSyntax: @K_str, ParseStream, ParseStreamPosition, emit

# from julia/JuliaSyntax/test/parse_stream.jl

code = """
using Jive
"""

st = ParseStream(code)
p1 = position(st)
@test emit(st, p1, K"toplevel") == ParseStreamPosition(0x00000001, 0x00000002)

end # module test_juliasyntax_parse_stream
