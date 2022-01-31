%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (unsigned_div_rem, assert_nn_le)

@storage_var
func tup_map (key : (felt, felt)) -> (val : felt):
end

@view
func view_tup_map_at {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (key : (felt, felt)) -> (val : felt):
    return tup_map.read (key)
end

################################

@constructor
func constructor{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } ():

    tup_map.write((1,1), 987)
    tup_map.write((3,9), 53)
    tup_map.write((5,10), 71)

    return ()
end

