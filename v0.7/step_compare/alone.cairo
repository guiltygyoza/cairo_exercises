%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@view
func view_square_result {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (x : felt) -> (y : felt):

    let (y) = square (x)

    return (y)
end


func square {} (x) -> (y):
    # no overflow protection
    return (x*x)
end

