import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('sine.cairo')
    print() # grab a newline here

    # Read memory at index 0 and assert it is 0
    # note: @view function is read-only, use call() to access
    # note: all storage initializes to 0
    # note: try printing out the return object of contract call to see its attributes; .result contains the actual function return
    ret = await contract.memory_read(key = 0).call()
    assert ret.result.value == 0
    print('> storage initializes to 0 successfully.')

    # Write memory at index 17, read it back and assert matching expectation;
    # read memory at index 35 and assert it is still 0
    # note: @external function changes the states of the blockchain/rollup. use execute() to access for cairo 0.10+
    # note: for cairo < 0.10 (e.g. 0.9.x, 0.8.x etc), we use invoke() to access @external function instead of execute()
    await contract.memory_write(key = 17, value = 683).execute() # <== use execute for cairo >= 0.10
    ret = await contract.memory_read(key = 17).call()
    assert ret.result.value == 683
    ret = await contract.memory_read(key = 35).call()
    assert ret.result.value == 0
    print('> storage read/write tested successfully.')

    # Call sine_7th() with theta=0 and print out return value, which should be 0
    ret = await contract.sine_7th(theta = 0).call()
    print(f'> sine_7th(theta = 0) returns: {ret.result.value}') # add '>' before our print messages to indicate they are our messages
    assert ret.result.value == 0