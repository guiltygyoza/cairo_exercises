import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_array():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('array.cairo')
    print(f'> array.cairo deployed.')

    for i in range(6):
        ret = await contract.dynamic_array_return(i).call()
        print(f'> dynamic_array_return({i}) yields {ret.result}')
