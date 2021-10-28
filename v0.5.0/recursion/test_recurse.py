import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_recurse():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('recurse.cairo')
    print(f'recurse.cairo deployed.')

    ret = await contract.run_simulation(start_pos = 5).call()
    print(f'run_simulation() returned: {ret.result.total_reward}')
    #assert ret.result.total_reward == 5*3