import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('dec_to_bin.cairo')
    print()

    dec_s = [65, 66, 67]
    for dec in dec_s:
        ret = await contract.dec_to_bin_padded(dec=dec, pad_to=8).call()
        print(f'{dec} is encoded into {ret.result.bin_padded}')