import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('struct_of_arrays.cairo')
    print(f'> struct_of_arrays.cairo deployed.')

    ret = await contract.retrieve_level().call()
    print(ret.result)