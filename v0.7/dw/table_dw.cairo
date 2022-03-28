%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.alloc import alloc

@view
func view_table {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (arr_len : felt, arr : felt*):

    let (arr_felt) = get_label_location(prefixes)
    let arr = cast(arr_felt, felt*)
    return (10, arr)

    prefixes:
    dw 111
    dw 222
    dw 333
    dw 444
    dw 555
    dw 111
    dw 222
    dw 333
    dw 444
    dw 555
end
