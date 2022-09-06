import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('split.cairo')

    for i in range(100):
        ret = await contract.hash_split_divide_mod2001(i).invoke()
        print(ret.result)
