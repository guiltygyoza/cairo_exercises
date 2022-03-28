#
# Code authored by @codemedian on Discord
# copying here for studying purposes
#

%lang starknet

from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.invoke import invoke
from starkware.cairo.common.uint256 import (Uint256, uint256_lt, uint256_add, uint256_eq)

struct SomeStruct:
    member a: Uint256
    member b: felt
end

@event
func emit_value (i : felt, val : felt):
end

@event
func emit_some_struct (some_struct : SomeStruct):
end

@storage_var
func sv_found_index() -> (val: felt):
end

func _dummy_foreach {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (callback, current: felt, count: felt) -> (res: felt):
    alloc_locals

    if count == 0:
        return (12345678)
    end

    let (cb_args : felt*) = alloc()
    assert [cb_args] = current
    assert [cb_args+1] = cast(syscall_ptr, felt)
    assert [cb_args+2] = cast(pedersen_ptr, felt)
    assert [cb_args+3] = cast(range_check_ptr, felt)
    assert [cb_args+4] = 10
    assert [cb_args+5]= 0
    assert [cb_args+6] = current * 3
    emit_value.emit ( i=1, val=current*3 )

    # let (local r: felt) = invoke(callback, 4, cb_args)
    invoke(callback, 7, cb_args)
    let r = [ap-1]
    let r2 = [ap-2]
    let r3 = [ap-3]
    let r4 = [ap-4]
    # emit_value.emit ( i=1, val=r )
    # emit_value.emit ( i=2, val=r2 )
    # emit_value.emit ( i=3, val=r3 )
    # emit_value.emit ( i=4, val=r4 )

    if r == 777:
        return (current)
    end

    return _dummy_foreach(callback, current+1, count-1)
end

func dummy_foreach {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }  (callback) -> (res: felt):
    return _dummy_foreach(callback, 0, 10)
end


# This funciton is called for every element in the iterated list
# @retval 1 = iteration stops and current index is returned to the caller
# @retval 0 = iteration continues
func loop_handler (syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ride_idx: felt, myStruct: SomeStruct) -> (syscall_pt: felt*, pedersen_pt: HashBuiltin*, range_check_ptr, res: felt):

    # with syscall_ptr, pedersen_ptr, range_check_ptr:
    #     emit_some_struct.emit (myStruct)
    # end

    # 3rd element in iteration will have this value
    if myStruct.b == 9:
        with syscall_ptr, pedersen_ptr, range_check_ptr:
            #sv_found_index.write(ride_idx)
            sv_found_index.write(982374)
        end
        return (syscall_ptr, pedersen_ptr, range_check_ptr, 777)
    end

    return (syscall_ptr, pedersen_ptr, range_check_ptr, 666)
end

@view
func find_ride {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (found_ride : felt):

    let (cb) = get_label_location(loop_handler)

    let (found_ride) = dummy_foreach(cb)

    return (found_ride)
end

@view
func get_ride {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (found_ride : felt):

    let (found_ride) = sv_found_index.read()
    return (found_ride)
end
