%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func notebook () -> (content : felt):
end

@view
func read_notebook {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } () -> (
        content : felt
    ):

    let (content) = notebook.read ()
    return (content)
end

@external
func record_my_ego_to_notebook {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } () -> ():
    alloc_locals

    #
    # 1. get who's calling this function
    #
    let (my_ego) = get_caller_address ()

    #
    # 2. write the caller address into `notebook`
    #
    notebook.write (my_ego)

    return ()
end
