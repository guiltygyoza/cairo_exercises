import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('search.cairo')
    print()

    GYOZA_ARGENT = int("0x077d04506374b4920d6c35ecaded1ed7d26dd283ee64f284481e2574e77852c6", 16)
    GYOZA_CLI_0  = int("0x787b926da58c91601b292abc63ed3e36b6afa08d530dcd0b5dfe2d507b84230", 16)

    ret = await contract.search_in_address_list(GYOZA_ARGENT).call()
    assert ret.result.found == 1
    ret = await contract.search_in_address_list(GYOZA_CLI_0).call()
    assert ret.result.found == 1

    ret = await contract.search_in_address_list(81237469).call()
    assert ret.result.found == 0