import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio

@pytest.mark.asyncio
async def test_player_queue ():

    starknet = await Starknet.empty()
    contract = await starknet.deploy('pair_struct.cairo')
    print()

    in_arr = [
        contract.Vec2(10, 20),
        contract.Vec2(100, 200),
        contract.Vec2(1000, 2000),
        contract.Vec2(10000, 20000),
        contract.Vec2(30000, 40000),
    ]
    ret = await contract.pairwise_average(in_arr).call()
    print(f'> out_arr: {ret.result.out_arr}')
    print(f'> ref_arr: {ret.result.ref_arr}')
    print(f'> idx_flatten_final : {ret.result.idx_flatten_final}')
    assert ret.result.idx_flatten_final == int(len(in_arr) * (len(in_arr)-1) / 2)
    print()

    arr = [(10,20), (100,200), (1000,2000), (10000,20000), (30000,40000)]
    for i in range(len(arr)):
        for j in range(i,len(arr)):
            x_avg = (arr[i][0] + arr[j][0])//2
            y_avg = (arr[i][1] + arr[j][1])//2
            arr[i] = (x_avg, y_avg)
            arr[j] = (x_avg, y_avg)
    print(arr)