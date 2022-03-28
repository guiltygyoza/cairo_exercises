%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

const CALLEE_ADDRESS = 0x06a617a2ab5701872114f0dc58f9b74f59ca2ea29e67138aff6cbe394ad743b5

@view
func view_square_result {syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    } (x : felt) -> (y : felt):

    let (y) = IContractCallee.square (CALLEE_ADDRESS, x)

    return (y)
end


@contract_interface
namespace IContractCallee:
    func square (x : felt) -> (y : felt):
    end
end