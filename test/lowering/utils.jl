module test_julialowering_utils

using Test
using JuliaLowering: JuliaLowering as JL
using JuliaSyntax: JuliaSyntax as JS
using .JS: SyntaxTree, parseall, @K_str

src = """
function f()
    xs
end
function g()
    xs
end
"""
ex = parseall(SyntaxTree, src)
@test JS.kind(ex) == K"toplevel"
@test JL._value_string(ex) == """::K\"toplevel\""""
@test sprint(JL._show_syntax_tree_sexpr, ex) == "(toplevel (function (call f) (block xs)) (function (call g) (block xs)))"

end # module test_julialowering_utils
