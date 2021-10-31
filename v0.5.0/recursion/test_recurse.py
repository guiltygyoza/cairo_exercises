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
    print(f'run_simulation(start_pos={start_pos}) returned: {ret.result.total_reward}')
    assert ret.result.total_reward == 5*start_pos

    start_pos = 777
    ret = await contract.run_simulation_countsteps(start_pos = start_pos).call()
    print(f'run_simulation_countsteps(start_pos={start_pos}) returned: steps_took={ret.result.steps_took}, total_reward={ret.result.total_reward}')
    assert ret.result.total_reward == 5*start_pos
    assert ret.result.steps_took == start_pos

    ## Testing cap reached before stopping
    start_pos = 555
    cap = 7
    ret = await contract.run_simulation_countsteps_capped(start_pos = start_pos, iter_cap = cap).call()
    print(f'run_simulation_countsteps_capped(start_pos={start_pos}, cap={cap}) returned: ', end='')
    print(f'steps_took={ret.result.steps_took}, total_reward={ret.result.total_reward}, final_bool_stopped={ret.result.final_bool_stopped}')
    assert ret.result.total_reward == 5*cap
    assert ret.result.steps_took == cap

    ## Testing stopping before cap reached
    start_pos = 555
    cap = 556
    ret = await contract.run_simulation_countsteps_capped(start_pos = start_pos, iter_cap = cap).call()
    print(f'run_simulation_countsteps_capped(start_pos={start_pos}, cap={cap}) returned: ', end='')
    print(f'steps_took={ret.result.steps_took}, total_reward={ret.result.total_reward}, final_bool_stopped={ret.result.final_bool_stopped}')
    assert ret.result.total_reward == 5*start_pos
    assert ret.result.steps_took == start_pos
