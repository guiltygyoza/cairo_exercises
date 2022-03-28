%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

@view
func return_literal {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (val : felt):

    return ('abc')
end
