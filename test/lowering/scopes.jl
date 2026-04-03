module test_julialowering_scopes

using Test
using JuliaLowering: JuliaLowering as JL
using TestJuliaLowering.ExpandForms: resolve_and_get_bindings

# from julia/JuliaLowering/test/scopes.jl
module AmbiguousLocal
    global x::Int = 0
end

# while loop
let bindings = resolve_and_get_bindings(AmbiguousLocal, :(while x < 5; x += 1; break; end))
    # BindingInfo(1, "<", :global, 43, mod=AmbiguousLocal, lambda_id=0, is_read=true, is_called=true)
    # BindingInfo(2, "x", :global, 45, mod=AmbiguousLocal, lambda_id=0, is_read=true)
    # BindingInfo(3, "x", :local, 48, lambda_id=1, is_ambiguous_local=true, is_read=true, is_assigned=true, is_assigned_once=true)
    # BindingInfo(4, "+", :global, 51, mod=AmbiguousLocal, lambda_id=0, is_read=true, is_called=true)
    @test bindings isa Vector{JL.BindingInfo}

    binfos = filter(b -> b.name == "x", bindings)

    local_binfo = only(filter(b -> b.kind === :local, binfos))
    # BindingInfo(3, "x", :local, 48, lambda_id=1, is_ambiguous_local=true, is_read=true, is_assigned=true, is_assigned_once=true)
    @test local_binfo.is_ambiguous_local === true
    @test local_binfo.mod === nothing

    global_binfo = only(filter(b -> b.kind === :global, binfos))
    # BindingInfo(2, "x", :global, 45, mod=AmbiguousLocal, lambda_id=0, is_read=true)
    @test global_binfo.is_ambiguous_local === false
    @test global_binfo.mod === AmbiguousLocal
end


#=
mutable struct JuliaLowering.BindingInfo
  id                 :: Int64
  name               :: String
  kind               :: Symbol
  node_id            :: Int64
  mod                :: Union{Nothing, Module}
  type               :: Union{Nothing, Int64}
  lambda_id          :: Int64
  is_const           :: Bool
  is_ssa             :: Bool
  is_internal        :: Bool
  is_ambiguous_local :: Bool
  unboxed            :: Bool
  is_nospecialize    :: Bool
  is_read            :: Bool
  is_called          :: Bool
  is_assigned        :: Bool
  is_assigned_once   :: Bool
  is_captured        :: Bool
  is_always_defined  :: Bool
  is_used_undef      :: Bool
=#

end # module test_julialowering_scopes
