import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_table ():

    starknet = await Starknet.empty()
    contract_dw = await starknet.deploy('table_dw.cairo')
    contract_assert = await starknet.deploy('table_assert.cairo')
    print()

    print('> dw based implementation:')
    ret = await contract_dw.view_table().call()
    print(ret)
    print()

    print('> assert based implementation')
    ret = await contract_assert.view_table().call()
    print(ret)