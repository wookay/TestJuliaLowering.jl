module test_juliasyntax_stm

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, parseall, @K_str, @stm

M = Module(:TestMod)
src = """
function f()
    xs
end
function g()
    xs
end
"""

ex = parseall(SyntaxTree, src)
@test ex.head === :toplevel
@test JS.numchildren(ex) == 2

end # module test_juliasyntax_stm
