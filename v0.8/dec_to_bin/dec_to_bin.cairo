%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.registers import get_label_location

@view
func dec_to_bin_padded {range_check_ptr} (
        dec : felt,
        pad_to : felt
    ) -> (bin_padded : felt):
    alloc_locals

    let (bin, digit) = recurse_binary_encode (dec)
    let (mult) = pow_10 (digit)
    let (bin_padded) = recurse_binary_pad (
        bin = bin,
        pad_with = 1,
        pad_count = pad_to - digit,
        mult = mult,
        idx = 0
    )

    return (bin_padded)
end

func recurse_binary_encode {range_check_ptr} (dec : felt) -> (bin : felt, digit : felt):
    alloc_locals

    if dec == 0:
        return (bin = 0, digit = 0)
    end

    let (q, r) = unsigned_div_rem(dec, 2)

    let (bin_ : felt, digit_ : felt) = recurse_binary_encode(q)

    let bin = (r+1) + 10 * bin_
    let digit = digit_ + 1

    return (bin = bin, digit = digit)
end

func recurse_binary_pad {range_check_ptr} (
        bin : felt,
        pad_with : felt,
        pad_count : felt,
        mult : felt,
        idx : felt
    ) -> (bin_padded):
    alloc_locals

    if idx == pad_count:
        return (bin_padded = bin)
    end

    let bin_padded_ = pad_with * mult + bin

    let (bin_padded) = recurse_binary_pad (
        bin = bin_padded_,
        pad_with = pad_with,
        pad_count = pad_count,
        mult = mult * 10,
        idx = idx + 1
    )

    return (bin_padded)
end

func pow_10 (n) -> (power):
    let (pows_address) = get_label_location (pows)
    return (power = [pows_address + n])

    pows:
    dw 1
    dw 10
    dw 100
    dw 1000
    dw 10000
    dw 100000
    dw 1000000
    dw 10000000
    dw 100000000
end