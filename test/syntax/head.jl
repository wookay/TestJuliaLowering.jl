module test_juliasyntax_head

using Test

@test Expr(:call, :+, 1, 2) == Meta.parse("1 + 2")
@test (quote end).head === :block
Expr(:static_parameter)

@test (begin end) === nothing
@test (let x = 1 end) === nothing

end # module test_juliasyntax_head
