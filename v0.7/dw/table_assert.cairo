%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.alloc import alloc

@view
func view_table {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (arr_len : felt, arr : felt*):
    alloc_locals

    let (arr) = alloc()
    assert arr[0] = 111
    assert arr[1] = 222
    assert arr[2] = 333
    assert arr[3] = 444
    assert arr[4] = 555
    assert arr[5] = 111
    assert arr[6] = 222
    assert arr[7] = 333
    assert arr[8] = 444
    assert arr[9] = 555

    return (10, arr)
end