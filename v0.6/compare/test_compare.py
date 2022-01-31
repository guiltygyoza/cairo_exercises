import pytest
import os
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_gates():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('compare.cairo')
    print(f'> compare.cairo deployed.')

    for i in range(5):
        ret = await contract.gate_ports_lookup(i).call()
        print(f'> gate_ports_lookup({i}) yields {ret.result}')
