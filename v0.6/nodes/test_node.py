import pytest
import os
from starkware.starknet.testing.starknet import Starknet

def felt_array_into_text (felt_array):
    hexstring = ''
    last_length = felt_array[-1]
    for felt in felt_array[:-2]:
        hexstr = hex(felt)[2:]
        hexstr = hexstr.rjust(62, '0')
        hexstring += hexstr
    hexstr = hex(felt_array[-2])[2:]
    hexstr = hexstr.rjust(last_length, '0')
    hexstring += hexstr

    text = bytestr = bytes.fromhex(hexstr)
    return bytestr.decode("utf-8")

    #return hexstring

@pytest.mark.asyncio
async def test_node():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('node.cairo')
    print(f'> node.cairo deployed.')

    for i in range(1,5):
        await contract.append_to_children(i*11).invoke()
        ret = await contract.read_children().call()
        print(ret.result)

    ret = await contract.payload_hexstring().call()
    arr = ret.result.arr
    text = felt_array_into_text(arr)
    print(f'> recovered payload text: {text}')