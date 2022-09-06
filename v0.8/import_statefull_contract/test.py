import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('mother.cairo')
    print()

    ret = await contract.mother_read_child_state().call()
    print(f"> mother_read_child_state(): {ret.result.child_val}")
    assert ret.result.child_val == 0

    await contract.mother_write_child_state(777).invoke()

    ret = await contract.mother_read_child_state().call()
    print(f"> mother_read_child_state(): {ret.result.child_val}")
    assert ret.result.child_val == 777

    ret = await contract.for_fun().call()
    print(f"> for_fun(): {ret.result.res}")
    assert ret.result.res == 48*256 + 48
