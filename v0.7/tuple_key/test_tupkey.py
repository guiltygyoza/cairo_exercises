import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_tupkey ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('tupkey.cairo')
    print()

    tup_s = [(1,1), (3,9), (5,10)]
    for tup in tup_s:
        ret = await contract.view_tup_map_at(tup).call()
        print(f'> view_tup_map_at( {tup} ): {ret.result.val}')