import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_recurse():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('structio.cairo')
    print(f'> structio.cairo deployed.')
    print(contract.Dynamics)
    print(contract.DuoDynamics)
    print(contract.ToyStruct)

    # Begin struct IO test
    dyn = contract.Dynamics(x=0, y=0, px=1, py=1)

    await contract.store_dynamics(dyn).invoke()
    print(f'> wrote dynamics: {dyn}')

    ret = await contract.retrieve_dynamics().call()
    print(f'> retrieved dynamics: {ret.result.dynamics}')

    assert dyn == ret.result.dynamics

    # Begin struct-of-struct IO test
    duo = contract.DuoDynamics(
        dyn1 = contract.Dynamics(x=0, y=1, px=2, py=3),
        dyn2 = contract.Dynamics(x=4, y=5, px=6, py=7)
    )

    await contract.store_duo_dynamics(duo).invoke()
    print(f'> wrote duo dynamics: {duo}')

    ret = await contract.retrieve_duo_dynamics().call()
    print(f'> retrieved duo dynamics: {ret.result.duoDynamics}')

    assert duo == ret.result.duoDynamics

    print(f'duo.dyn1 = {duo.dyn1}')
    print(f'duo.dyn2 = {duo.dyn2}')
