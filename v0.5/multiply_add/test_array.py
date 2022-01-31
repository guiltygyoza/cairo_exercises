import pytest
import os
from starkware.starknet.testing.starknet import Starknet

PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2

def adjust (e):
    return e if e < PRIME_HALF else e-PRIME

@pytest.mark.asyncio
async def test_array():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('array_fc0_ele0.cairo')
    print(f'> array_fc0_ele0.cairo deployed.')

    x = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,18,18,18,126,136,175,26,166,255,247,127,0,0,0,0,0,0,0,0,0,0,0,0,30,36,94,154,170,253,253,253,253,253,225,172,253,242,195,64,0,0,0,0,0,0,0,0]
    ret = await contract.multiply_add(x = x).call()
    print(f'multiply_add({x}) returns: { adjust(ret.result.y) }')