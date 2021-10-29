%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

struct Dynamics:
    member x : felt
    member y : felt
    member px : felt
    member py : felt
end

@storage_var
func StoredDynamics () -> (dynamics : Dynamics):
end

@external
func store_dynamics {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (dynamics : Dynamics) -> ():
    StoredDynamics.write(dynamics)
    return ()
end

@view
func retrieve_dynamics {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (dynamics : Dynamics):
    return StoredDynamics.read()
end
