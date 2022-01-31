%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.math_cmp import (is_not_zero, is_le)

@storage_var
func queue (idx : felt) -> (val : felt):
end

@storage_var
func queue_len () -> (len : felt):
end

@view
func view_queue_as_array {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (arr_len : felt, arr : felt*):
    alloc_locals

    let (arr) = alloc()
    let (arr_len) = queue_len.read()
    _recurse_populate_array_from_queue (arr_len, arr, 0)

    return (arr_len, arr)
end

################################

@constructor
func constructor{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (arr_len : felt, arr : felt*):

    _recurse_push_array_to_queue (arr_len, arr, 0)
    queue_len.write (arr_len)

    return ()
end

func _recurse_push_array_to_queue{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (len : felt, arr : felt*, idx : felt) -> ():

    if idx == len:
        return ()
    end

    queue.write (idx, [arr+idx])

    _recurse_push_array_to_queue (len, arr, idx+1)
    return ()
end

func _recurse_populate_array_from_queue {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (len : felt, arr : felt*, idx : felt) -> ():

    if idx == len:
        return ()
    end

    let (val) = queue.read (idx)
    assert [arr+idx] = val

    _recurse_populate_array_from_queue (len, arr, idx+1)
    return ()
end

################################

@external
func pairwise_average {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
    ) -> ():

    let (len) = queue_len.read()

    _recurse_outer_loop (len, 0)

    return ()
end

func _recurse_inner_loop{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        first : felt,
        last : felt,
        idx : felt
    ) -> ():

    if idx == last:
        return ()
    end

    let (val_first) = queue.read (first)
    let (val_idx) = queue.read (idx)
    let (avg, _) = unsigned_div_rem (val_first + val_idx, 2)
    queue.write (first, avg)
    queue.write (idx, avg)

    _recurse_inner_loop (first, last, idx+1)
    return ()
end

func _recurse_outer_loop{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        last : felt,
        idx : felt
    ) -> ():

    if idx == last:
        return ()
    end

    _recurse_inner_loop (idx, last, idx+1)

    _recurse_outer_loop (last, idx+1)
    return ()
end

