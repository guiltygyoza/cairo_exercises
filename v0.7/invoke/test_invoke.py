import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_invoke ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('invoke.cairo')
    print()

    ret = await contract.find_ride().call()
    print(f'> invoke::find_ride() returns: {ret.result}')
    assert ret.result.found_ride == 3
