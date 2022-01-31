import pytest
from starkware.starknet.testing.starknet import Starknet

@pytest.mark.asyncio
async def test_database():
    starknet = await Starknet.empty()

    print()

    contract_callee = await starknet.deploy("ContractCallee.cairo")
    contract_caller = await starknet.deploy("ContractCaller.cairo")

    TEST_KEY = 5
    TEST_VAL = 123

    ## Write data to callee
    await contract_callee.write_data(key=TEST_KEY, value=TEST_VAL).invoke()

    print(f'> contract_callee.write_data({TEST_KEY}, {TEST_VAL}) completed.')

    ## Read data from callee to confirm previous write
    ret = await contract_callee.query_data(key=TEST_KEY).call()
    assert ret.result.value == TEST_VAL

    print(f'> contract_callee.query_data({TEST_KEY}) returned {TEST_VAL} correctly.')

    ## Let caller retrieve data from callee, double it and return
    ret = await contract_caller.retrieve_and_double(
        callee_address = contract_callee.contract_address,
        key = TEST_KEY).call()
    assert ret.result.result == TEST_VAL*2

    print(f'> contract_caller.retrieve_and_double({TEST_KEY}) returned {ret.result.result} which is equal to {TEST_VAL*2}')

    print(f'> test passed.')

