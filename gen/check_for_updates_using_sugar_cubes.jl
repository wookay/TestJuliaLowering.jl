# check_for_updates_using_sugar_cubes.jl

using Test
using SugarCubes: code_block_with, has_diff
# https://github.com/wookay/SugarCubes.jl

function check_the_code_block_diff(src_path::String,
                                   src_signature::Union{Nothing, Expr},
                                   dest_path::String,
                                   dest_signature::Union{Nothing, Expr} ;
                                   skip_lines = (src = Int[], dest = Int[]))
    printstyled(stdout, "✔ ", color = :blue)
    print(stdout, " ", basename(src_path), " ")
    src_filepath = normpath(@__DIR__, "..", src_path)
    dest_filepath = normpath(@__DIR__, "..", dest_path)
    @test isfile(src_filepath)
    @test isfile(dest_filepath)
    src_block = code_block_with(; filepath = src_filepath, signature = src_signature)
    if src_block.signature !== nothing
        (depth, kind, sig) = src_block.signature.layers[end]
        printstyled(stdout, sig.args[1], color = :cyan)
    end
    dest_block = code_block_with(; filepath = dest_filepath, signature = dest_signature)
    @test has_diff(src_block, dest_block; skip_lines) === false
    println(stdout)
end

f = :(function resolve_and_get_bindings(
          mod::Module, ex;
          world::UInt = Base.get_world_counter(),
          soft_scope::Union{Nothing,Bool} = nothing,) end)
check_the_code_block_diff(
    "src/scopes.jl", :(module Scopes $f end),
    "sources/JuliaLowering/test/scopes.jl", f
)
