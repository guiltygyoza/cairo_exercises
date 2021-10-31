import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_pseudorandom():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('pseudorandom.cairo')
    print(f'> pseudorandom.cairo deployed.')

    seed = 76
    await contract.initialize_seed(seed).invoke()
    print(f'> initialized seed with {seed}')

    N = 20
    print(f'> begin requesting {N} pseudorandom numbers')
    for i in range(N):
        ret = await contract.get_pseudorandom().invoke()
        print(ret.result.num, end=' ')
    print()

    print(f'> begin requesting {N} pseudorandom numbers mod 10')
    for i in range(N):
        ret = await contract.get_pseudorandom_mod(10).invoke()
        print(ret.result.num, end=' ')
    print()