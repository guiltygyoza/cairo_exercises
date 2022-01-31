%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

## append-only list
@storage_var
func Children (idx : felt) -> (val : felt):
end

@storage_var
func Children_length () -> (len : felt):
end

#########################

@external
func append_to_children {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (child_addr : felt) -> (len : felt):
    ## input: value to append to Children
    ## output: length of Children after appending a new child
    alloc_locals

    let (local cur_len) = Children_length.read()
    Children.write(cur_len, child_addr)
    Children_length.write(cur_len + 1)

    return (cur_len + 1)
end

@view
func read_child_at_idx {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (idx : felt) -> (child_addr : felt):

    let (child_addr) = Children.read(idx)
    return (child_addr)
end

@view
func read_children {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (children_len : felt, children : felt*):
    alloc_locals

    let (local children) = alloc()
    let (local children_len) = Children_length.read()

    _recursive_read_children (children, children_len, 0)

    return (children_len, children)
end

func _recursive_read_children {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        arr : felt*, len, idx
    ) -> ():

    if idx == len:
        return ()
    end

    let (child_addr) = Children.read(idx)
    assert [arr+idx] = child_addr

    _recursive_read_children (arr, len, idx+1)
    return ()
end

#########################

@view
func payload_hexstring {range_check_ptr} () -> (arr_len : felt, arr : felt*):
    alloc_locals

    let (local arr) = alloc()
    assert [arr+0] = 379694426685219972803782586816357409
    assert [arr+1] = 30

    return (2, arr)
end