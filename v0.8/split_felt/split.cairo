%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, split_felt
from starkware.cairo.common.hash import hash2

@storage_var
func cache () -> (value : felt):
end

@external
func hash_split_divide_mod2001 {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        entropy : felt
    ) -> (
        high : felt,
        low : felt,
        new_cache : felt
    ):
    alloc_locals

    #
    # Read from cache
    #
    let (curr_cache) = cache.read ()

    #
    # Hash with `entropy`
    #
    let (hashed_cache) = hash2 {hash_ptr = pedersen_ptr} (curr_cache, entropy)

    #
    # Split
    #
    let (high, low) = split_felt (hashed_cache)

    #
    # `low` % 2001
    #
    let (_, new_cache) = unsigned_div_rem (low, 2001)

    #
    # Store back to cache
    #
    cache.write (new_cache)

    return (high, low, new_cache)
end
