module JuliaSyntaxFormatterExt

using JuliaSyntaxFormatter: SyntaxTree, is_leaf, kind, @K_str, is_operator, escape_julia_string, JuliaSyntax, provenance
import JuliaSyntaxFormatter: format_token_str_default

# from JuliaSyntaxFormatter/src/JuliaSyntaxFormatter.jl
function format_token_str_default(ex::SyntaxTree; include_var_id=false)
    @assert is_leaf(ex)
    # See also JuliaLowering._value_string
    k = kind(ex)
    str = k == K"Identifier" || is_operator(k) ? ex.name_val :
          k == K"String"     ? escape_julia_string(ex.value) :
          k == K"Placeholder" ? ex.name_val :
          k == K"StrMacroName" || k == K"CmdMacroName" ? ex.name_val :
          k == K"SSAValue"   ? "%"                   :
          k == K"BindingId"  ? "#"                   :
          k == K"label"      ? "label"               :
          k == K"core"       ? "Core.$(ex.name_val)" :
          k == K"top"        ? "Base.$(ex.name_val)" : # top === Base except for bootstrap
          k == K"Symbol"     ? ":$(ex.name_val)"     :
          k == K"globalref"  ? "$(ex.mod).$(ex.name_val)" :
          k == K"symboliclabel" ? "@label $(ex.name_val)" :
          k == K"symbolicgoto" ? "@goto $(ex.name_val)" :
          k == K"slot"       ? "slot"   :
          k == K"TOMBSTONE"  ? "🪦 "     :
          k == K"latestworld" ? "latestworld"     :
          k == K"SourceLocation" ? "SourceLocation:$(JuliaSyntax.filename(ex)):$(join(JuliaSyntax.source_location(ex), ':'))" :
          begin
              val = get(ex, :value, nothing)
              isnothing(val) ? "❓" : repr(val)
          end
    id = get(ex, :var_id, nothing)
    if isnothing(id)
        id = get(ex, :id, nothing)
    end
    if !isnothing(id) && (k == K"SSAValue" || k == K"BindingId" || k == K"label" || k == K"slot" || include_var_id)
        idstr = replace(string(id),
                        "0"=>"₀", "1"=>"₁", "2"=>"₂", "3"=>"₃", "4"=>"₄",
                        "5"=>"₅", "6"=>"₆", "7"=>"₇", "8"=>"₈", "9"=>"₉")
        str = "$(str)$idstr"
    end
    if k == K"slot" || k == K"BindingId"
        p = provenance(ex)[1]
        while p isa SyntaxTree
            if kind(p) == K"Identifier"
                str = "$(str)/$(p.name_val)"
                break
            end
            p = provenance(p)[1]
        end
    end
    return str
end

end # module JuliaSyntaxFormatterExt
