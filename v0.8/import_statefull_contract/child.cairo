%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func child_state () -> (val : felt):
end


func read_child_state {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (val : felt):

    let (val) = child_state.read ()

    return (val)
end


func write_child_state {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    new_val : felt) -> ():

    child_state.write (new_val)

    return ()
end