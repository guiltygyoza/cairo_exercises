import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_literal ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('literal.cairo')
    print()

    ret = await contract.return_literal().call()
    print(ret.result)