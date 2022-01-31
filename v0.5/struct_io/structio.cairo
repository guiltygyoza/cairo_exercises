%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

struct Dynamics:
    member x : felt
    member y : felt
    member px : felt
    member py : felt
end

struct DuoDynamics:
    member dyn1 : Dynamics
    member dyn2 : Dynamics
end

struct ToyStruct:
    member x : felt
    member y : felt
end

@storage_var
func StoredDynamics () -> (dynamics : Dynamics):
end

@storage_var
func StoredDuoDynamics () -> (duoDynamics : DuoDynamics):
end

########################

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


@external
func store_duo_dynamics {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (duoDynamics : DuoDynamics) -> ():
    StoredDuoDynamics.write(duoDynamics)
    return ()
end

@view
func retrieve_duo_dynamics {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (duoDynamics : DuoDynamics):
    let (duo) = StoredDuoDynamics.read()
    let dyn1 = duo.dyn1
    let dyn2 = duo.dyn2
    return (duo)
end

@view
func retrieve_debug_toystruct {
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } () -> (toy : ToyStruct):
    let toy = ToyStruct(x=555,y=666)
    return (toy)
end
