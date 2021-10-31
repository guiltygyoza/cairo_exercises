%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (unsigned_div_rem, split_felt)

# Seed (for pseudorandom) that players add to.
@storage_var
func entropy_seed(
    ) -> (
        value : felt
    ):
end

# Gets hard-to-predict values as pseudorandom number
# Referencing the great Perama (@eth_worm) at https://github.com/dopedao/RYO/blob/main/contracts/GameEngineV1.cairo
@external
func initialize_seed{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(seed : felt) -> ():

    entropy_seed.write(seed)

    return ()
end

@external
func get_pseudorandom{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (
        num : felt
    ):
    # Seed is fed to linear congruential generator.
    # seed = (multiplier * seed + increment) % modulus.
    # Params from GCC. (https://en.wikipedia.org/wiki/Linear_congruential_generator).
    let (old_seed) = entropy_seed.read()
    # Snip in half to a manageable size for unsigned_div_rem.
    let (left, right) = split_felt(old_seed)
    let (_, new_seed) = unsigned_div_rem(1103515245 * right + 1, 2**31)

    # Number has form: 10**9 (xxxxxxxxxx).
    # Should be okay to write multiple times to same variable
    # without increasing storage costs of this transaction.
    entropy_seed.write(new_seed)

    return (new_seed)
end

@external
func get_pseudorandom_mod{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(mod : felt) -> (num : felt):

    let (prand_num) = get_pseudorandom()
    let (_, num) = unsigned_div_rem(prand_num, mod)

    return (num)
end
