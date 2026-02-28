module test_juliasyntax_kinds

using Test
using JuliaSyntax: @K_str, is_prec_unicode_ops

@test K"BEGIN_UNICODE_OPS" <= K"√" <= K"END_UNICODE_OPS"
@test is_prec_unicode_ops(K"√")

# from julia/JuliaSyntax/src/julia/kinds.jl
#=
is_identifier(k::Kind)                 = K"BEGIN_IDENTIFIERS" <= k <= K"END_IDENTIFIERS"
is_contextual_keyword(k::Kind)         = K"BEGIN_CONTEXTUAL_KEYWORDS" <= k <= K"END_CONTEXTUAL_KEYWORDS"
is_error(k::Kind)                      = K"BEGIN_ERRORS" <= k <= K"END_ERRORS" || k == K"ErrorInvalidOperator" || k == K"Error**"
is_keyword(k::Kind)                    = K"BEGIN_KEYWORDS" <= k <= K"END_KEYWORDS"
is_block_continuation_keyword(k::Kind) = K"BEGIN_BLOCK_CONTINUATION_KEYWORDS" <= k <= K"END_BLOCK_CONTINUATION_KEYWORDS"
is_literal(k::Kind)                    = K"BEGIN_LITERAL" <= k <= K"END_LITERAL"
is_number(k::Kind)                     = K"BEGIN_NUMBERS" <= k <= K"END_NUMBERS"
is_operator(k::Kind)                   = K"BEGIN_OPS" <= k <= K"END_OPS"
is_word_operator(k::Kind)              = (k == K"in" || k == K"isa" || k == K"where")

is_prec_assignment(x)      = K"BEGIN_ASSIGNMENTS"           <= kind(x) <= K"END_ASSIGNMENTS"
is_prec_pair(x)            = K"BEGIN_PAIRARROW"             <= kind(x) <= K"END_PAIRARROW"
is_prec_conditional(x)     = K"BEGIN_CONDITIONAL"           <= kind(x) <= K"END_CONDITIONAL"
is_prec_arrow(x)           = K"BEGIN_ARROW"                 <= kind(x) <= K"END_ARROW"
is_prec_lazy_or(x)         = K"BEGIN_LAZYOR"                <= kind(x) <= K"END_LAZYOR"
is_prec_lazy_and(x)        = K"BEGIN_LAZYAND"               <= kind(x) <= K"END_LAZYAND"
is_prec_comparison(x)      = K"BEGIN_COMPARISON"            <= kind(x) <= K"END_COMPARISON"
is_prec_pipe(x)            = K"BEGIN_PIPE"                  <= kind(x) <= K"END_PIPE"
is_prec_colon(x)           = K"BEGIN_COLON"                 <= kind(x) <= K"END_COLON"
is_prec_plus(x)            = K"BEGIN_PLUS"                  <= kind(x) <= K"END_PLUS"
is_prec_bitshift(x)        = K"BEGIN_BITSHIFTS"             <= kind(x) <= K"END_BITSHIFTS"
is_prec_times(x)           = K"BEGIN_TIMES"                 <= kind(x) <= K"END_TIMES"
is_prec_rational(x)        = K"BEGIN_RATIONAL"              <= kind(x) <= K"END_RATIONAL"
is_prec_power(x)           = K"BEGIN_POWER"                 <= kind(x) <= K"END_POWER"
is_prec_decl(x)            = K"BEGIN_DECL"                  <= kind(x) <= K"END_DECL"
is_prec_where(x)           = K"BEGIN_WHERE"                 <= kind(x) <= K"END_WHERE"
is_prec_dot(x)             = K"BEGIN_DOT"                   <= kind(x) <= K"END_DOT"
is_prec_unicode_ops(x)     = K"BEGIN_UNICODE_OPS"           <= kind(x) <= K"END_UNICODE_OPS"
is_syntax_kind(x)          = K"BEGIN_SYNTAX_KINDS"          <= kind(x) <= K"END_SYNTAX_KINDS"
is_syntactic_assignment(x) = K"BEGIN_SYNTACTIC_ASSIGNMENTS" <= kind(x) <= K"END_SYNTACTIC_ASSIGNMENTS"
=#

end # module test_juliasyntax_kinds
