module test_julialowering_flisp

using Test
using JuliaLowering: JuliaLowering as JL

# from julia/JuliaLowering/src/compat.jl
@test Base.isoperator(:√)
@test JL.is_dotted_operator(".√")

end # module test_julialowering_flisp
