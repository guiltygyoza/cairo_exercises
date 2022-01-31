import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_player_queue ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('pair_struct.cairo')
    print()

    ret = await contract.pairwise_average([
        contract.Vec2(10, 20),
        contract.Vec2(100, 200),
        contract.Vec2(1000, 2000)
    ]).call()
    print(ret.result)

    arr = [(10,20), (100,200), (1000,2000)]
    for i in range(len(arr)):
        for j in range(i,len(arr)):
            x_avg = (arr[i][0] + arr[j][0])//2
            y_avg = (arr[i][1] + arr[j][1])//2
            arr[i] = (x_avg, y_avg)
            arr[j] = (x_avg, y_avg)
    print(arr)