module test_juliasyntax_stm

using Test
using JuliaSyntax: JuliaSyntax as JS
using .JS: Syntax, parseall

M = Module(:TestMod)
src = """
function f()
    xs
end
function g()
    xs
end
"""

ex = parseall(Syntax, src)
@test ex.head === :toplevel
@test JS.numchildren(ex) == 2

end # module test_juliasyntax_stm
