%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

# The interface for the other function is defined.
@contract_interface
namespace IContractCallee:
    func query_data(key : felt) -> (value : felt):
    end
end

@view
func retrieve_and_double {
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        callee_address : felt,
        key : felt
    ) -> (
        result : felt
    ):

    let (value) = IContractCallee.query_data(callee_address, key)
    return (value * 2)
end
