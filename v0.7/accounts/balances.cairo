%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func Balances (address : felt) -> (balance : felt):
end

#########################

@external
func udpate_balance {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } (
        my_address : felt,
        new_balance : felt
    ) -> ():

    let (caller_address : felt) = get_caller_address()

    with_attr error_message("caller must provide her own address correctly."):
        assert caller_address = my_address
    end

    Balances.write(my_address, new_balance)

    return ()
end

@view
func view_balance {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    } (address : felt) -> (balance : felt):

    let (balance) = Balances.read(address)

    return (balance)
end