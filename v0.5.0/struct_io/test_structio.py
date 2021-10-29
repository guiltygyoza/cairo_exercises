import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_recurse():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('structio.cairo')
    print(f'structio.cairo deployed.')

    d1 = contract.Dynamics(x=0, y=0, px=1, py=1)

    await contract.store_dynamics(d1).invoke()
    print(f'wrote dynamics: {d1}')

    ret = await contract.retrieve_dynamics().call()

    print(f'retrieve dynamics: {ret.result.dynamics}')

    assert d1 == ret.result.dynamics
