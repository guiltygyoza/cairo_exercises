%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_nn, assert_not_zero, assert_le
#from starkware.cairo.common.math_cmp import is_le
#from starkware.starknet.common.syscalls import get_caller_address

@view
func multiply_add {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(
        input_len : felt,
        input : felt*
    ) -> (
        output : felt
    ):
    #alloc_locals

    assert_le (input_len, 3)

    let result = [input] * -5 + [input + 1] * 17 + [input + 2] *53

    return (result)
end
