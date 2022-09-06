%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2

@view
func hash_with_12345678 {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        x : felt
    ) -> (
        hash : felt
    ):
    alloc_locals

    let (hash) = hash2 {hash_ptr = pedersen_ptr} (x, 12345678)

    return (hash)
end
