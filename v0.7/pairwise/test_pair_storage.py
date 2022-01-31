import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_player_queue ():

    arr = [50, 100, 200]

    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source = 'pair_storage.cairo',
        constructor_calldata = [len(arr)] + arr)
    print()

    ret = await contract.view_queue_as_array().call()
    print(f'> Queue: {ret.result.arr}')

    await contract.pairwise_average().invoke()

    ret = await contract.view_queue_as_array().call()
    arr_contract = ret.result.arr
    print(f'> Queue: {arr_contract}')

    for i in range(len(arr)):
        for j in range(i, len(arr)):
            avg = (arr[i] + arr[j])//2
            arr[i] = avg
            arr[j] = avg

    ## Check contract return against answer
    for i in range(len(arr)):
        assert arr[i] == arr_contract[i]