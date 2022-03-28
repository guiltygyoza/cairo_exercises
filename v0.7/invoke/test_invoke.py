import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_invoke ():

    starknet = await Starknet.empty()
    print()

    # contract = await starknet.deploy('invoke.cairo')
    # ret = await contract.find_ride().call()
    # print(f'> invoke::find_ride() returns: {ret.result}')
    # assert ret.result.found_ride == 3

    contract2 = await starknet.deploy('invoke2.cairo')
    ret = await contract2.find_ride().call()
    print(ret.result)

    events = ret.main_call_events
    if len(events)>0:
        for event in events:
            print(f'event emitted: {event}')

    ret = await contract2.get_ride().call()
    print(ret.result)



