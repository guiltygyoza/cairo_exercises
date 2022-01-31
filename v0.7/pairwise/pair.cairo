%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.math_cmp import (is_not_zero, is_le)
from starkware.cairo.common.default_dict import (default_dict_new, default_dict_finalize)
from starkware.cairo.common.dict import (dict_write, dict_read, dict_update)
from starkware.cairo.common.dict_access import DictAccess

const ENERGIES_COUNT = 3
struct Energies:
    member e1 : felt
    member e2 : felt
    member e3 : felt
end

struct Pair:
    member x : felt
    member y : felt
end

@storage_var
func energies () -> (e : Energies):
end

@view
func view_energies {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (e : Energies):
    return energies.read()
end

################################

@constructor
func constructor{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } ():

    energies.write(Energies(
        e1 = 100,
        e2 = 100,
        e3 = 100
    ))

    return ()
end

@external
func exert_impact_to_head{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (impact_energy : felt) -> ():

    let (curr_energies : Energies) = energies.read()
    let energies_at_impact = Energies(
        e1 = curr_energies.e1 + impact_energy,
        e2 = curr_energies.e2,
        e3 = curr_energies.e3
    )

    let (energies_after_impact) = _collision (energies_at_impact)
    energies.write(energies_after_impact)

    return ()
end

func _collision{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (e_start : Energies) -> (e_end : Energies):
    alloc_locals

    ## 1. init dictionary to store starting energies
    let (local dict) = default_dict_new(default_value = 0)
    dict_write {dict_ptr=dict} (key = 1, new_value = e_start.e1)
    dict_write {dict_ptr=dict} (key = 2, new_value = e_start.e2)
    dict_write {dict_ptr=dict} (key = 3, new_value = e_start.e3)

    ## 2. init index pairs as array of tuples
    let (pairs : Pair*) = alloc()
    assert [pairs] = Pair(1,2)
    assert [pairs + Pair.SIZE] = Pair(1,3)
    assert [pairs + 2*Pair.SIZE] = Pair(2,3)

    ## 3. go over predefined index pairs, each time
    ##    read from dictionary, perform collision, and store back to dictionary
    let (dict_) = _recurse_pairwise_collision (3, pairs, dict, 0)

    ## 4. finalize dictionary for soundness
    default_dict_finalize(
        dict_accesses_start = dict_,
        dict_accesses_end = dict_,
        default_value = 0
    )

    ## 5. read from dictionary to update energies
    let (e1_after) = dict_read {dict_ptr=dict_} (key = 1)
    let (e2_after) = dict_read {dict_ptr=dict_} (key = 2)
    let (e3_after) = dict_read {dict_ptr=dict_} (key = 3)
    return (Energies(
        e1 = e1_after,
        e2 = e2_after,
        e3 = e3_after
    ))

end

func _recurse_pairwise_collision {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        len : felt,
        pairs : Pair*,
        dict : DictAccess*,
        idx : felt
    ) -> (dict_ : DictAccess*):

    if idx == len:
        return (dict)
    end

    let pair : Pair = cast([pairs + idx * Pair.SIZE], Pair)
    let (p0) = dict_read {dict_ptr=dict} (key = pair.x)
    let (p1) = dict_read {dict_ptr=dict} (key = pair.y)
    let (avg, _) = unsigned_div_rem(p0 + p1, 2)
    dict_write {dict_ptr=dict} (key = pair.x, new_value = avg)
    dict_write {dict_ptr=dict} (key = pair.y, new_value = avg)

    let (dict_) = _recurse_pairwise_collision (len, pairs, dict, idx+1)
    return (dict_)
end
