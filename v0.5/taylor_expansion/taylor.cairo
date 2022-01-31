%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import (signed_div_rem)
from starkware.cairo.common.math_cmp import is_le

const RANGE_CHECK_BOUND = 2 ** 64
const SCALE_FP = 1000 * 1000
const PI_DIV2 = 1570796 # x * 1000 * 1000

### Utility functions for fixed-point arithmetic
func mul_fp {range_check_ptr} (
        a : felt,
        b : felt
    ) -> (
        c : felt
    ):
    # signed_div_rem by SCALE_FP after multiplication
    tempvar product = a * b
    let (c, _) = signed_div_rem(product, SCALE_FP, RANGE_CHECK_BOUND)
    return (c)
end

func mul_fp_ul {range_check_ptr} (
        a : felt,
        b_ul : felt
    ) -> (
        c : felt
    ):
    let c = a * b_ul
    return (c)
end

func div_fp_ul {range_check_ptr} (
        a : felt,
        b_ul : felt
    ) -> (
        c : felt
    ):
    let (c, _) = signed_div_rem(a, b_ul, RANGE_CHECK_BOUND)
    return (c)
end

@view
func sine_5th{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(theta : felt) -> (value : felt):
    alloc_locals

    # sin(theta) ~= theta - theta^3/3! + theta^5/5!
    let (local theta_2) = mul_fp (theta, theta)
    let (local theta_3) = mul_fp (theta_2, theta)
    let (local theta_5) = mul_fp (theta_2, theta_3)

    let (theta_3_div6) = div_fp_ul (theta_3, 6)
    let (theta_5_div120) = div_fp_ul (theta_5, 120)

    let value = theta - theta_3_div6 + theta_5_div120

    return (value)
end


@view
func sine_7th{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(theta : felt) -> (value : felt):
    alloc_locals

    # sin(theta) ~= theta - theta^3/3! + theta^5/5! - theta^7/7!
    let (local theta_2) = mul_fp (theta, theta)
    let (local theta_3) = mul_fp (theta_2, theta)
    let (local theta_5) = mul_fp (theta_2, theta_3)
    let (local theta_7) = mul_fp (theta_2, theta_5)

    let (theta_3_div6) = div_fp_ul (theta_3, 6)
    let (theta_5_div120) = div_fp_ul (theta_5, 120)
    let (theta_7_div5040) = div_fp_ul (theta_7, 5040)

    let value = theta - theta_3_div6 + theta_5_div120 - theta_7_div5040

    return (value)
end

@view
func arccosine_5th{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(x : felt) -> (value : felt):
    alloc_locals

    let (local x_2) = mul_fp (x,x)
    let (local x_3) = mul_fp (x_2, x)
    let (local x_5) = mul_fp (x_2, x_3)

    let (local x_3_term)  = div_fp_ul (x_3, 6)
    let (x_5_term_) = mul_fp_ul (x_5, 3)
    let (local x_5_term)  = div_fp_ul (x_5_term_, 40)

    let value = PI_DIV2 - (x + x_3_term + x_5_term)

    return (value)
end

@view
func arccosine_7th{
        range_check_ptr
    }(x : felt) -> (value : felt):
    alloc_locals

    let (local x_2) = mul_fp (x,x)
    let (local x_3) = mul_fp (x_2, x)
    let (local x_5) = mul_fp (x_2, x_3)
    let (local x_7) = mul_fp (x_2, x_5)

    let (local x_3_term)  = div_fp_ul (x_3, 6)
    let (x_5_term_) = mul_fp_ul (x_5, 3)
    let (local x_5_term)  = div_fp_ul (x_5_term_, 40)
    let (x_7_term_) = mul_fp_ul (x_7, 15)
    let (x_7_term) = div_fp_ul (x_7_term_, 336)

    let value = PI_DIV2 - (x + x_3_term + x_5_term + x_7_term)

    return (value)
end

@view
func arccosine_7th_tappered{
        range_check_ptr
    } (x : felt) -> (y : felt):
    alloc_locals
    ## Tappered: use linear function down to 0 when x is above a threshold
    ## at x=0.88075, error between cairo-7th and python's math.acos() is 5.011267190668979 %
    ## set threshold at 0.88 and acos(0.88) = 0.495
    ## set linear function to ramp from (0.88, 0.495) to (1, 0)
    ## if x>=0.88 => y = 0.495 - (x-0.88)/(1-0.88)*0.495
    ##            => y = 4.125 * (1-x)
    const ACOS_X_THRESH = 880 * 1000 # 0.88 * 1000 * 1000
    const ACOS_SLOPE = 4125 * 1000 # 4.125 * 1000 * 1000

    let (bool_x_above_threshold) = is_le (ACOS_X_THRESH, x)
    local y
    if bool_x_above_threshold == 1:
        let (y_) = mul_fp (ACOS_SLOPE, 1*SCALE_FP - x)
        assert y = y_

        tempvar range_check_ptr = range_check_ptr
    else:
        let (y_) = arccosine_7th(x)
        assert y = y_

        tempvar range_check_ptr = range_check_ptr
    end

    return (y)
end