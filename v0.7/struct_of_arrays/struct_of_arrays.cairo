%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

## Ideally we want to be able to do this! function can't return struct of felt* at the moment
# struct Level:
#     member score_ball_array_len : felt
#     member score_ball_array     : felt*
#     member taboo_ball_array_len : felt
#     member taboo_ball_array     : felt*
# end

struct Point:
    member x : felt
    member y : felt
end

struct Level:
    member score_ball_0 : Point
    member score_ball_1 : Point
    member score_ball_2 : Point
    member taboo_ball   : Point
end

#########################

@view
func retrieve_level {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } () -> (level : Level):

    alloc_locals

    local score_ball_arr
    local taboo_ball_arr

    assert [score_ball_arr + 0] = Point (x=0, y=1)
    assert [score_ball_arr + 1] = Point (x=2, y=3)

    assert [taboo_ball_arr + 0] = Point (x=4, y=5)
    assert [taboo_ball_arr + 1] = Point (x=6, y=7)

    let level = Level(
        score_ball_array_len = 2,
        score_ball_array     = score_ball_arr,
        taboo_ball_array_len = 2,
        taboo_ball_array     = taboo_ball_arr
    )

    return (level)
end