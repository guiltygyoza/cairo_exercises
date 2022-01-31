%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

@view
func dynamic_array_return {range_check_ptr} (idx : felt) -> (arr_len : felt, arr : felt*):
    alloc_locals

    let (local arr) = alloc()

    if idx == 0:
        assert [arr + 0] = 0
        assert [arr + 1] = 1
        return (2, arr)
    end

    if idx == 1:
        assert [arr + 0] = 2
        assert [arr + 1] = 3
        assert [arr + 2] = 4
        return (3, arr)
    end

    if idx == 2:
        assert [arr + 0] = 5
        assert [arr + 1] = 6
        assert [arr + 2] = 7
        assert [arr + 3] = 8
        assert [arr + 4] = 9
        return (5, arr)
    end

    if idx == 3:
        assert [arr + 0] = 10
        assert [arr + 1] = 11
        assert [arr + 2] = 12
        assert [arr + 3] = 13
        assert [arr + 4] = 14
        assert [arr + 5] = 15
        return (6, arr)
    end

    if idx == 4:
        assert [arr + 0] = 16
        assert [arr + 1] = 17
        assert [arr + 2] = 18
        assert [arr + 3] = 19
        assert [arr + 4] = 20
        assert [arr + 5] = 21
        assert [arr + 6] = 22
        return (7, arr)
    else:
        assert [arr + 0] = 23
        assert [arr + 1] = 24
        assert [arr + 2] = 25
        assert [arr + 3] = 26
        assert [arr + 4] = 27
        assert [arr + 5] = 28
        assert [arr + 6] = 29
        assert [arr + 7] = 30
        return (8, arr)
    end
end