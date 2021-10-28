import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_recurse():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('recurse.cairo')
    print(f'recurse.cairo deployed.')

    start_pos = 123
    ret = await contract.run_simulation(start_pos = start_pos).call()
    print(f'run_simulation() returned: {ret.result.total_reward}')
    assert ret.result.total_reward == 5*start_pos