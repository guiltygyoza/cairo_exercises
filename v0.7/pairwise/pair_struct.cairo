%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import (unsigned_div_rem, assert_nn_le)
from starkware.cairo.common.math_cmp import (is_not_zero, is_le)
from starkware.cairo.common.default_dict import (default_dict_new, default_dict_finalize)
from starkware.cairo.common.dict import (dict_write, dict_read)
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.memcpy import memcpy

struct Vec2:
    member x : felt
    member y : felt
end

@view
func pairwise_average {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr} (
        in_arr_len : felt,
        in_arr : Vec2*
    ) -> (
        out_arr_len : felt,
        out_arr : Vec2*,
        ref_arr_len : felt,
        ref_arr : Vec2*,
        idx_flatten_final : felt
    ):
    alloc_locals

    #
    # create dict_init and populate with in_arr
    #
    let (dict_init : DictAccess*) = default_dict_new (default_value = 0)
    let (dict_in) = _recurse_populate_dict_with_vec2_array (dict_init, in_arr_len, in_arr, 0)

    #
    # create an identical copy of dict_in
    #
    let (dict_init_copy : DictAccess*) = default_dict_new (default_value = 0)
    let (dict_in_copy) = _recurse_populate_dict_with_vec2_array (dict_init_copy, in_arr_len, in_arr, 0)

    #
    # double recursion to perform pairwise operation on dictionary
    #
    let (dict_out, idx_flatten_final) = _recurse_outer_loop (dict_in, in_arr_len, 0, 0)

    #
    # populate output array with dict_out
    #
    let (out_arr : Vec2*) = alloc()
    let out_arr_len = in_arr_len
    _recurse_populate_vec2_array_with_dict (dict_out, out_arr_len, out_arr, 0)

    #
    # populate ref array with dict_in_copy
    #
    let (ref_arr : Vec2*) = alloc()
    let ref_arr_len = in_arr_len
    _recurse_populate_vec2_array_with_dict (dict_in_copy, ref_arr_len, ref_arr, 0)

    #
    # finalize dictionary TODO
    #

    return (out_arr_len, out_arr, ref_arr_len, ref_arr, idx_flatten_final)
end

func _recurse_populate_vec2_array_with_dict  {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        dict : DictAccess*,
        len : felt,
        arr : Vec2*,
        idx : felt
    ) -> ():

    if idx == len:
        return ()
    end

    let (vec_ptr) = dict_read {dict_ptr=dict} (key = idx)
    let vec = [cast(vec_ptr, Vec2*)]
    assert arr[idx] = vec

    _recurse_populate_vec2_array_with_dict (dict, len, arr, idx+1)
    return ()
end

func _recurse_populate_dict_with_vec2_array {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        dict : DictAccess*,
        len : felt,
        arr : Vec2*,
        idx : felt
    ) -> (
        dict_ : DictAccess*
    ):

    if idx == len:
        return (dict)
    end

    dict_write {dict_ptr=dict} (key = idx, new_value = cast(arr + idx*Vec2.SIZE, felt) )

    let (dict_) = _recurse_populate_dict_with_vec2_array (dict, len, arr, idx+1)
    return (dict_)
end

func _recurse_inner_loop{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        dict : DictAccess*,
        first : felt,
        last : felt,
        idx : felt,
        idx_flatten : felt
    ) -> (
        dict_ : DictAccess*,
        idx_flatten_inner : felt
    ):

    if idx == last:
        return (dict, idx_flatten)
    end

    let (vec_a_ptr) = dict_read {dict_ptr=dict} (key = first)
    let (vec_b_ptr) = dict_read {dict_ptr=dict} (key = idx)
    let vec_a = [cast(vec_a_ptr, Vec2*)]
    let vec_b = [cast(vec_b_ptr, Vec2*)]

    let (x_avg, _) = unsigned_div_rem(vec_a.x + vec_b.x, 2)
    let (y_avg, _) = unsigned_div_rem(vec_a.y + vec_b.y, 2)

    let (vec_avg_ptr : Vec2*) = alloc()
    assert [vec_avg_ptr] = Vec2(x_avg, y_avg)
    let vec_avg_ptr_felt : felt = cast(vec_avg_ptr, felt)

    dict_write {dict_ptr=dict} (key = first, new_value = vec_avg_ptr_felt)
    dict_write {dict_ptr=dict} (key = idx, new_value = vec_avg_ptr_felt)

    let (dict_, idx_flatten_inner) = _recurse_inner_loop (dict, first, last, idx+1, idx_flatten+1)
    return (dict_, idx_flatten_inner)
end

func _recurse_outer_loop{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (
        dict : DictAccess*,
        last : felt,
        idx : felt,
        idx_flatten : felt
    ) -> (
        dict_outer : DictAccess*,
        idx_flatten_outer : felt
    ):

    if idx == last-1:
        return (dict, idx_flatten)
    end

    let (dict_inner, idx_flatten_inner) = _recurse_inner_loop (dict, idx, last, idx+1, idx_flatten)

    let (dict_outer, idx_flatten_outer) = _recurse_outer_loop (dict_inner, last, idx+1, idx_flatten_inner)
    return (dict_outer, idx_flatten_outer)
end

