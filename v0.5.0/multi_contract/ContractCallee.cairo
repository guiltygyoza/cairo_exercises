%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func data (key : felt) -> (value : felt):
end

@view
func query_data{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(key : felt) -> (value : felt):

    let (value) = data.read(key)
    return (value)
end

@external
func write_data{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(key : felt, value : felt) -> ():

    data.write(key, value)
    return ()
end
