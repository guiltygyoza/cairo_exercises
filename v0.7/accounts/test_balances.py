import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import asyncio
from Signer import Signer

NUM_SIGNING_ACCOUNTS = 2
DUMMY_PRIVATE = 9812304879503423120395
users = []

### Reference: https://github.com/perama-v/GoL2/blob/main/tests/test_GoL2_infinite.py


@pytest.fixture(scope='module')
def event_loop():
    return asyncio.new_event_loop()

@pytest.fixture(scope='module')
async def account_factory():
    starknet = await Starknet.empty()

    accounts = []
    print(f'Deploying {NUM_SIGNING_ACCOUNTS} accounts...')
    for i in range(NUM_SIGNING_ACCOUNTS):
        signer = Signer(DUMMY_PRIVATE + i)
        account = await starknet.deploy(
            "Account.cairo",
            constructor_calldata=[signer.public_key]
        )
        await account.initialize(account.contract_address).invoke()
        users.append({
            'signer' : signer,
            'account' : account
        })

        print(f'Account {i} is: {hex(account.contract_address)}')

    # Admin is usually accounts[0], user_1 = accounts[1].
    # To build a transaction to call func_xyz(arg_1, arg_2)
    # on a TargetContract:

    # await Signer.send_transaction(
    #   account=accounts[1],
    #   to=<TargetContract's address>,
    #   selector_name='func_xyz',
    #   calldata=[arg_1, arg_2],
    #   nonce=current_nonce)

    # Note that nonce is an optional argument.
    return starknet, accounts


@pytest.fixture(scope='module')
async def test_factory(account_factory):
    starknet, accounts = account_factory
    contract = await starknet.deploy("balances.cairo")
    return starknet, contract, accounts


@pytest.mark.asyncio
async def test_balances(test_factory):

    starknet, contract, accounts = test_factory

    user = users[1]
    balance = 170
    print(f'> sending signed transaction from user #1 to set balance to {balance}')
    await user['signer'].send_transaction(
      account=user['account'],
      to=contract.contract_address,
      selector_name='udpate_balance',
      calldata=[user['account'].contract_address, balance]
    )

    ret = await contract.view_balance(user['account'].contract_address).call()
    balance_retrieved = ret.result.balance
    print(f"> view_balance(user #1's address): {balance_retrieved}")
    assert balance_retrieved == balance