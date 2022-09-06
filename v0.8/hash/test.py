import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('hash.cairo')
    print()

    ret = await contract.hash_with_12345678(521118).call()
    print(ret.result.hash)