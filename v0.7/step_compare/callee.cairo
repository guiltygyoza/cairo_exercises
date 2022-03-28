%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@view
func square {} (x) -> (y):
    # no overflow protection
    return (x*x)
end

