using Jive
@If VERSION >= v"1.14.0-DEV.2435" module test_julialowering_kinds
# julia commit e1b2c72e96

using Test
using JuliaLowering: JuliaLowering as JL
using .JL: @K_str

# from julia/JuliaLowering/src/kinds.jl

# Call into foreign code
K"foreigncall"

# Look up a symbol in foreign code
K"foreignglobal"

# Wraps the first argument of a foreigncall / foreignglobal when it
# should not be lowered (and should mostly be treated as :inert), but
# requires scope resolution and special conversion to Expr.
K"foreignsymbol"

end # module test_julialowering_kinds
