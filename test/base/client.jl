module test_base_client

using JuliaSyntax
using JuliaLowering

# from julia/base/client.jl

# function uninit_frontend()
JuliaSyntax.enable_in_core!
JuliaLowering.activate!

end # module test_base_client
