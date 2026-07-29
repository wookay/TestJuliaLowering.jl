using Jive
# julia commit fd4f64f14d
@If VERSION >= v"1.14.0-DEV.2823" module test_juliasyntax_typegroup

using Test
using JuliaLowering: JuliaLowering as JL
using InteractiveUtils

# from julia/JuliaLowering/test/typedefs.jl
test_mod = @__MODULE__

@test JL.include_string(test_mod, """
typegroup
    struct Node
        edges::Vector{Edge}
    end

    struct Edge
        from::Node
        to::Node
    end
end
"""; version=v"1.14") === nothing

@test fieldtype(Node, :edges) === Vector{Edge}
@test fieldtype(Edge, :from)  === Node
@test fieldtype(Edge, :to)    === Node

ms = @methods Core.resolve_typegroup(mod::Module, typevars::Core.SimpleVector, struct_infos::Core.SimpleVector, old_types::Core.SimpleVector)
method = first(ms)
@test method isa Method
@test method.sig === Tuple{typeof(Core.resolve_typegroup), Module, Core.SimpleVector, Core.SimpleVector, Core.SimpleVector}

end # module test_juliasyntax_typegroup
