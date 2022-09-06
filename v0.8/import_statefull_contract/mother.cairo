%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from child import (read_child_state, write_child_state)

@view
func mother_read_child_state {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (child_val : felt):

    let (child_val) = read_child_state ()

    return (child_val)
end

@external
func mother_write_child_state {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    new_child_val : felt) -> ():

    write_child_state (new_child_val)

    return ()
end

@view
func for_fun {} () -> (res : felt):
    return ('00')
end
