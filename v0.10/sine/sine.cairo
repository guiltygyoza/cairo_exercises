%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import signed_div_rem, sqrt
from starkware.cairo.common.math_cmp import is_le

//
// Constants
//
const SCALE_FP = 10**20;
const SCALE_FP_SQRT = 10**10;
const RANGE_CHECK_BOUND = 2 ** 120;
const TWO_PI = 6283185 * SCALE_FP / 1000000;
const PI = TWO_PI / 2;

//
// Storage, getter & setter
//
@storage_var
func memory (key : felt) -> (value: felt) {
}

@view
func memory_read {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    key : felt) -> (value: felt) {
    let (v) = memory.read (key);
    return (value = v);
}

@external
func memory_write {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    key : felt, value : felt
) -> () {
    memory.write (key, value);
    return ();
}

//
// Utility functions for fixed-point arithmetic
//
func sqrt_fp{range_check_ptr}(x: felt) -> felt {
    let x_ = sqrt(x); // notice: sqrt() now returns a single felt, not a tuple anymore (tuple is returned for cairo < 0.10)
    let y = x_ * SCALE_FP_SQRT;  // compensate for the square root
    return y;
}

func mul_fp{range_check_ptr}(a: felt, b: felt) -> felt {
    // signed_div_rem by SCALE_FP after multiplication
    tempvar product = a * b;
    let (c, _) = signed_div_rem(product, SCALE_FP, RANGE_CHECK_BOUND);
    return c;
}

func div_fp{range_check_ptr}(a: felt, b: felt) -> felt {
    // multiply by SCALE_FP before signed_div_rem
    tempvar a_scaled = a * SCALE_FP;
    let (c, _) = signed_div_rem(a_scaled, b, RANGE_CHECK_BOUND);
    return c;
}

func mul_fp_ul{range_check_ptr}(a: felt, b_ul: felt) -> felt {
    let c = a * b_ul;
    return c;
}

func div_fp_ul{range_check_ptr}(a: felt, b_ul: felt) -> felt {
    let (c, _) = signed_div_rem(a, b_ul, RANGE_CHECK_BOUND);
    return c;
}

@view
func sine_7th{range_check_ptr}(theta: felt) -> (value: felt) {
    alloc_locals;

    //
    // sin(theta) ~= theta - theta^3/3! + theta^5/5! - theta^7/7!
    //

    local theta_norm;
    let bool = is_le(PI, theta);
    if (bool == 1) {
        assert theta_norm = theta - PI;
    } else {
        assert theta_norm = theta;
    }

    let theta_2 = mul_fp(theta_norm, theta_norm);
    let theta_3 = mul_fp(theta_2, theta_norm);
    let theta_5 = mul_fp(theta_2, theta_3);
    let theta_7 = mul_fp(theta_2, theta_5);

    let theta_3_div6 = div_fp_ul(theta_3, 6);
    let theta_5_div120 = div_fp_ul(theta_5, 120);
    let theta_7_div5040 = div_fp_ul(theta_7, 5040);

    let value = theta_norm - theta_3_div6 + theta_5_div120 - theta_7_div5040;

    if (bool == 1) {
        return (-value,);
    } else {
        return (value,);
    }
}


@view
func chaining_mul_fp_for_fun {range_check_ptr} (
    a_fp : felt, b_fp : felt, c_fp : felt, d_fp : felt) -> (z_fp : felt) {

    let z_fp = mul_fp (
        d_fp, mul_fp (
            c_fp, mul_fp (
                b_fp,
                a_fp
            )
        )
    );

    return (z_fp = z_fp);
}