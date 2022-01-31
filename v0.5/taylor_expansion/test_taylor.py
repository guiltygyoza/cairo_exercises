import pytest
import os
from starkware.starknet.testing.starknet import Starknet
import math

SCALE_FP = 1000 * 1000
PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2

def adjust_neg (x):
    if x > PRIME_HALF:
        return x-PRIME
    else:
        return x

@pytest.mark.asyncio
async def test_pseudorandom():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('taylor.cairo')
    print(f'> taylor.cairo deployed.')
    print()

    deg_s = [0, 30, 45, 60]
    theta_s = [0, 0.523599, 0.785398, 1.0472]
    theta_fp_s = []
    for t in theta_s:
        theta_fp_s.append( int(t * SCALE_FP) )

    print('> testing taylor expansion of sine in Cairo')
    for d, t, t_fp in zip(deg_s, theta_s, theta_fp_s):
        ret5 = await contract.sine_5th(t_fp).call()
        estimated5 = ret5.result.value / SCALE_FP
        ret7 = await contract.sine_7th(t_fp).call()
        estimated7 = ret7.result.value / SCALE_FP
        answer = math.sin(t)
        print(f'sine({d} deg): cairo 5th-order approx.={estimated5}; 7th-order approx.={estimated7}; math.sin={answer}')
    print()

    N = 40
    x_s = [0.8+ i*0.19/N for i in range(N)]
    x_fp_s = []
    for x in x_s:
        x_fp_s.append( int(x * SCALE_FP) )
    print('> testing taylor expansion of arccosine in Cairo')
    for x, x_fp in zip(x_s, x_fp_s):
        ret5 = await contract.arccosine_5th(x_fp).call()
        estimated5 = adjust_neg(ret5.result.value) / SCALE_FP

        ret7 = await contract.arccosine_7th(x_fp).call()
        estimated7 = adjust_neg(ret7.result.value) / SCALE_FP

        ret7_ = await contract.arccosine_7th_tappered(x_fp).call()
        estimated7_ = adjust_neg(ret7_.result.y) / SCALE_FP

        answer = math.acos(x)
        print(f'acos({x}):\nCairo 7th-order approx.={estimated7}; Cairo tappered: {estimated7_}; math.acos={answer}\n> error={(estimated7-answer)/answer*100} %')
        print(f'error with tappered: {(estimated7_-answer)/answer*100} %')
        print()


