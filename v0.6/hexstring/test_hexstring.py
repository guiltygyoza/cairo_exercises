import pytest
import os
import binascii
from starkware.starknet.testing.starknet import Starknet
import math

PRIME = 3618502788666131213697322783095070105623107215331596699973092056135872020481
PRIME_HALF = PRIME//2

def felt_array_into_hexstring (felt_array):
    hexstring = ''
    last_length = felt_array[-1]
    for felt in felt_array[:-2]:
        hexstr = hex(felt)[2:]
        hexstr = hexstr.rjust(62, '0')
        hexstring += hexstr
    hexstr = hex(felt_array[-2])[2:]
    hexstr = hexstr.rjust(last_length, '0')
    hexstring += hexstr
    return hexstring

def hybrid_array_into_hexstring (hybrid_array):
    assert len(hybrid_array) % 2 == 0 # length is even-number
    hexstring = ''
    i=0
    while i<len(hybrid_array):
        value = hybrid_array[i]
        length = hybrid_array[i+1]
        hexstr = hex(value)[2:]
        hexstr = hexstr.rjust(length, '0')
        hexstring += hexstr
        i += 2
    return hexstring

@pytest.mark.asyncio
async def test_hexstring():
    starknet = await Starknet.empty()
    print()

    contract = await starknet.deploy ('hexstring.cairo')
    print(f'> hexstring.cairo deployed.')
    print()

    ret = await contract.header().call()
    header = felt_array_into_hexstring( ret.result.z )
    assert header == HEADER_HEX

    ret = await contract.track_tempo_hybrid_array(3).call()
    track_tempo = hybrid_array_into_hexstring( ret.result.z )
    #assert track_tempo == TEMPO_HEX

    ret = await contract.track_1().call()
    track_1 = felt_array_into_hexstring( ret.result.z )
    assert track_1 == TRACK1_HEX

    ret = await contract.track_2().call()
    track_2 = felt_array_into_hexstring( ret.result.z )
    assert track_2 == TRACK2_HEX

    concat = header + track_tempo + track_1 + track_2

    with open('test.mid', 'wb') as fout:
        fout.write( binascii.unhexlify(concat) )

########################################################

HEADER_HEX = '4d54686400000006000100030078'
TEMPO_HEX = '4d54726b000001e400ff0308756e7469746c656400ff7f0300004100ff58040402180800ff5902000000ff5103124f808d10ff5103137ab428ff510314585528ff5103137ab48120ff5103124f80a350ff5103137ab428ff510314585528ff5103137ab48120ff5103124f808f78ff5103137ab428ff510314585528ff5103137ab48120ff5103124f808838ff51031312d078ff510313e71c78ff5103154a9578ff510315cc5b28ff510316547728ff510316e36028ff5103124f80b630ff5103137ab428ff510314585528ff5103137ab48120ff5103124f808430ff5103137ab428ff510314585528ff5103137ab428ff5103124f808578ff51031312d078ff510314585578ff510316e36078ff51031817c378ff51031458558148ff510313e71c28ff5103137ab428ff51031312d028ff510312af2a28ff5103124f80bb08ff5103137ab428ff510314585528ff5103137ab428ff5103124f808360ff5103137ab428ff510314585528ff510315cc5b28ff5103137ab48740ff5103124f808648ff510314585528ff510316e36028ff51031a286e28ff5103124f808648ff510314585528ff510316e36028ff51031a286e28ff51031458558170ff510315cc5b8170ff510316e3608268ff51031a286e28ff51031c9c3828ff51031e848028ff5103249f0000ff2f00'
TRACK1_HEX = '4d54726b000018a600ff21010000ff0324317374204d766d7420536f6e617461204e6f2e31342c204f7075732032372c204e6f2e3200b0000000c00000b0403801405801407f26903d1e283d0000402b284000283d1d283d00004020284000283d19283d00004019284000283d1d283d0000401d28400003b0405802401802400013402801405803407f0a903d1b26401b033d002540002a3d1d283d0000401b284000283d19283d00004022284000283d1f283d0000402528400000392901b040480240001b403801407f09903900003d19283d0000402128400000391c283900003d21283d0000402028400000392400b040000140581a403803407f0a903e25263900023e0000422a284200003921283900003e1f283e0000422226b040280290420001b0400014405802407f11903c1a283c00004224284200283d1c283d0000402128400005b0404802400014401803405801407f09903d1a283d00003f2e283f00283c26283c00003f19283f0005b0406802402801400016404801407f31903d23283d00283d16283d00004015284000283d1b283d00004027284000004437283d1c283d0000401a0a44000044301e44000040000044370bb040480240001b903f1f01b0403801407f01406825903f00004221284200283f1a283f0000421b284200283f1f283f00004221274400014200004431283f20283f000042260a44000044341e440000420000443d08b0405803400016401802404802407f03903d1d283d0000401e284000283d17283d0000402027440001400000453600392608b0403803400013406801407f09903d1a013900273d0000422028420000391a283900003d1b283d0000422126b040580190450001420000443301b040000e401802404801407f16903b33283b00004028284000283b18283b0000402224b040380290423500b04000019044000140000039260fb0404802407f17903900003b1d0942001f3b00003f121e3928093900013f00004730283b22283b00003f28274700013f0000403305b0403801400011403802407f0f903b23283b00004019274000014000283b18283b0000401e284000283b18283b00004024284000283b1a283b0000401c28400002b0405803401802400015404803407f09903b23283b0000401e284000283b16283b0000401b284000283b18283b0000401928400000433a283b21283b000040290a43000043251e430000400000433007b040580140001b404802407f03903b24283b00004129284100283b19283b0000411e284100283b18283b00004122274300014100004337283b23283b0000412a0a43000043381e430000410000433506b0403802400017405802407f07903c25283c0000402428400006b0403801400013402801407f0d903b24283b0000401d28400002b0403803400010402801406803407f0f903d26283d0000402427430001400000423c283d2b283d0000402427420001400000422b07b0406801401803400014402802406802407f05903b1b283b00003e19283e00283b25283b00003e21274200013e0000433a05b0403801400013405802407f0d903b2a283b00003d2f274300013d0000403603b0401803400007401803404801407f17903b2b283b00003d36274000013d0000423601b0406801400017402802406801407f0c903b1f283b00003e25283e00283b1b283b00003e25274200013e0000423001b0406801401803400017403803407f09903a1e283a00003d25283d00283a20283a00003d1e283b1e013d0000420004b0405801400015403801407f0c903b00003e18283e0000421f284200003b30283b00003e27283e00004228284200003b2e283b00003f31283f0000423125b0406803904200004742003b3800b0400010404801407f17903b00003f22283f000042281e3b3109470001420000485205b040180140000f404801407f11903b0001403428400000432125b0402803904300003b2a00b0400007401801404803407f1b9040282840000243180e3b0018b0404802904300003b3900b0400006403802405802407f1e903b00004029284000004337274800014300004636003b2f00b0402803400008403802406803407f18903b0000401f28400000432227460001430000472c003b1802b0403803400011403803407f0f903b00003f20283f0000421e284200003b1e283b00003f19283f0000421e284200003b13283b00003f22283f0000422426b0402801904700014200003b2c00473e01b0400009402801405802407f1b903b00003f22284221083f000f4200073b2209470001484c08b0405802401802400004402802404802407f14903b0000401a28400000431c26b0405802904300003b2501b0401802400007402801405802407f1b903b0000401f28400000432424b0405802401802904300003b3e00b0400005401801403802406802407f1e903b00004024284000004327274800014300003b2f00463a00b0403801400004401802403801405803407f1d903b0000401928400000431627460001430000472f003b2102b0403803400011404803407f0f903b00003f1b283f0000421b284200003b1c283b00003f1f283f0000422224b0403802400001904700014200003b1c0047290cb0402803406801407f18903b00003e16283e00004121284100003b1d283b00003e1f283e00004120274700014100003b1f00472d00b040180240000e404802407f16903b00003d1d283d00004420284400003b19283b00003d1d283d0000441927470001440000453c00391a00b0404802400014404803407f0f903900003d19283d0000421f284200003924283900003d17283d0000422627450001420000434302b0404803400011403803407f0f903b1f283b00003e2a283e00283b24283b00003e3a25b0401802904300013e0000423e00b0400010403802407f16903922283900003f37283f00283918283900003f25274200013f00003d2002b0405801400013403803407f37903924283900503926273d00013900003d2e00b0405802400010402802407f61406801402801903d00013d2201b0400006401801403803406801407f69405802903d0001b0400016407f12903919283900003d28283d00003931283900003d1b283d00004227284200003d2e283d0000421c284200004527284500003d40004947283d0000422028420000451d0a49000049361e490000450000493d003d220fb0401803400014405802407f00904423013d00274400004725284700003d23283d0000441a28440000471f274900014700003d22283d00004420284400004718284700004939003d20283d0000441f2844000047220a490000492e1e490000470000493d003d1f0ab0402802400012403801407f09903d00004222284200004528284500003d2e28422028420000452225b0403802903d00004900014500003c3f00484400b0400010404802407f16903c0000422128420000452820b0404803400004904800014500004951003d4508b0404803407f1d903d0000422528420000452521b0402803400003904900014500003f40004b4e0cb0402801407f1b903f00004223284200004424284400003f34283f0000421928420000442e284400003f2b283f00004221284200004422274b00014400004b47003f4503b0400012406802407f11903f00004222284200004424274b00014400004c4700403803b0402803400010402801407f1190400000442428440000492528490000401e28400000441928440000492024b0406801400003904900004b38003f2d0db0404803407f18903f0000422c28420000452e26b0401801904b00004c00014500004947003d2601b040000e404802407f17903d0000403828400000463325b040480290490001460000482900b0400011405803407f14903c18283c00003f21274800013f0000443a283c21283c00003f2f274400013f00004542263c1d283c00023f1f274500013f0000422b263c1d283c00023f25274200013f0000b0401801400010403803407f815940680390394a00b040000a402802405801407f6a9039006cb040380340000b403802407f2590402826441b02400026440002494028401f28400000441b274900014400004c4628401928400000441d274c0001440000493326401c28400002441e24b040680140000290490001440010b0402801407f67903d3b773d00014044774000013d2f75b0405802903d0001b0400014403801407f1390391f283900283c33283c0000392c283900003f3a283f00003c39283c00004232284200003f30283f0000453828450000423228420000483928480001b0400013402801407f13903d22283d00284038284000003d27283d0000443e28440000402e28400000493f28490000442e284400004c39284c0000491a284900004421284400003d2d00b0401801400014402802407f11903d0000433428430000403528400000463828460000432328430000493828490000462c284600004c42284c0000492a284900004f3f284f00004c28284c0000522128520000421d03b0403804400012403802407f0d90420000482928480000452d284500004b36284b00004821284800004e30284e00004b30284b0000512b285100004e2d284e00005444285400005128285100005730285700005439285400004e20284e0000511c285100004b2f284b00004e27284e00004824284800004b37284b0000452228450000482128480000422c28420000451a284500003f1f283f00004231284200003c27283c00003f19283f0000393002b0406801402803400007403803406802407f16903900003c21283c0028391e2839004cb040280140000f407f4490392328390001b0406801400013403802407f6190393e2839004eb0403803400010403801407f3e90392825b04000039039000cb0402801406803407f4090392026b040000290390012b0406803407f639039522839004db0403801400011405802407f3f90392421b040280340000490390001b0402802404803407f4a90392923b040680240000390390011b0404801407f6690393628390048b0401803400011401803404802407f3f903d2c283d00503d2523b0405801400004903d000fb0403802407f17903924283900003d2b283d0026391c283900023d1926b0406802903d0001b0400014405801407f3a903c22283c00503c21283c0001b0400014402801407f3a903d19283d00283d21283d0000401a284000283d20283d0000401b28400000442c283d1d283d0000401b08443c0244001c440002400000443a05b0405801400019403801407f08903f23283f00004223284200283f17283f0000421e284200283f11283f00004228274400014200004435283f20283f000042260a44000044311e440000420000443606b0406802400017407f09903d1e283d00004025284000283d1a283d0000402e27440001400000453b00392700b0406802400014407f12903900003d25283d0000422328420000391f283900003d1d283d0000422126b040280190450001420000443600b0400010404802407f16903b2a283b0000402c284000283b26283b0000402624b040000390440001400000393000423d0fb0404801407f18903900003b20283b00003f1e1f3923084200013f00004738283900003b1a283b00003f32274700013f0000402808b0402802400012403803407f09903b34283b0000400000402a284000003b34283b00004023284000004423284400003b34283b0000402028400000442028440000473f003b35283b000040222840000044270a47000047241e4700004400004739003b2802b0404801400016405801407f0e903b0000421b284200004515284500003b2a283b0000421628420000451a284500003b21283b00004219284200004520274700014500003b2c004744283b0000421c2842000045210a47000047311cb0404802904700004500004738003b2700b0400014405802407f10904022023b00264000024424284400003b2f264028023b0026400002441b20b0405801400006904700014400003c4600484b0cb0405803407f19903c0000422128420000443323b0403802400002904800014400003d3100494e0db0404802407f19904034013d0027400000443726b0403801904900014400003f41004b4e00b0400014407f14903f0000422a28420000442a284400003f31283f0000422728420000442e26b0402801904b0001440000403b004c5000b0400012406802407f1490400000442228440000492428490000402428400000441b28440000491f274c00014900003e25004a3600b0406802400012403802407f12903e00004212284200004513284500003e1d283e00004224284200004519274a00014500004831003c2000b0401802400012407f14903c0000421928420000441e284400003c21283c0000421a28420000442224b040180240000190480001440000493a003d2110b0403802407f16903d0000401c28400000441d284400003d1c283d0000402028400000441f284400003d1f283d0000411928410000442223b0406802400002904900014400003d2d0049470bb0404802407f1b903d0000411c28410000442b1e3d26094900014400004a4006b0400010406803407f0e903d0001422728420000451f25b0400003904500003d310db0403802407f19903d0000422a28420000451921b0404803400004904500003946003d390ab0403802407f1c903d0000421c284200004529273900004a00014500003d2c00483c01b040680240000f406803407f13903d0000421d28420000452327480001450000492e003d2105b0400014406801407f0e903d0000411b284100004422284400003d1e283d0000411b284100004423284400003d1e283d0000411a284100004425274900014400003d31004941283d000041222841000044251e3d2c094900014400004a58273d0001422628420000451a20b0403803400005904500003d2d05b0402802407f21903d0000421728420000452421b040180340000490450000393c003d3b06b0403801407f21903d0000422328420000452e25b0404801400001903900004a00014500003d2400483a0bb0404802407f1b903d0000421f28420000452127480001450000492e003d1f02b040680140180340000e405802407f12903d0000411f28410000441b284400003d22283d0000411a28410000442520b0404801400006904900014400003d120049390cb0402801407f1b903d0000421c28420000451d284500003d19283d0000421a28420000451b27490001450000473c003b2002b0403801400013406801407f11903b00004219284200004518284500003b2d283b00004216284200004521284500003b20283b0000421728420000452725b0405801400001904700014500003b250047370fb0402802406801407f16903b0000402a28400000442c24b040000390470001440000393300453c0cb0403801407f1b90390000402128400000442123b040480140000390450001440000392800453908b0401803405801407f1c903900003f2c283f0000422821b04048034000039045000142000044440db0404803407f18903f22283f0000422526b04000019044000142000044390fb0403802407f17903d26283d0000402727440001400000423802b0400012402802407f12903d21283d00003f22283f00283d25283d00003f2425b0403802904200013f0000444300b0400011407f17903d22283d00003f21274400013f0000454600393805b040000140580f402802407f11903900003d23283d00003f2725b0406802904500013f0000443d00b0400011406803407f14903d1f283d0000401f284000283d1a283d0000402424b040180390440001400000442c00b0400010405801407f17903c16283c00003f21274400013f00283c1b283c00003f2b21b0405803400004903f00003d280db0405803407f40903d2a273d00013d00283d1c283d00004026284000283d20283d00004026284000283d25283d0000402428400003b0405802400015405801407f0d903f26283f00004224284200283f1c283f0000421e284200283f22283f0000421e284200283f22283f0000422728420001b0402802400013407f12904033284000003d21283d0000444128440000402a28400000493d284900004435284400004c4a284c000049371ab040680140000d90490000504906b0403802407f20905000004c34284c0000493828490000484201b0405802400012407f13904800004b34284b0000452e284500004840284800004228284200004527284500003f39283f0000422d28420000393423b0404801400004903900003c430ab0404802407f1c903c00503d3a00b0400015407f13903d0000403d284000003d2d283d0000443e28440000403528400000494328490000442a284400004c4a284c000049301ab040680240180240000a9049000050480ab0405802407f1c905000004c3e284c0000493828490000484000b0401801400010406803407f14904800004b2e284b0000452c284500004837284800004232284200004531284500003f3e283f0000423128420000393e1cb040280240000a903900003c3f05b0403801407f22903c004eb0401802903d3901b0400013407f3c903d33273d00013d00004031284000003d25283d0081203d31283d008431b0405806407f8169903d31816f3d00013d21816db04048014018034000816e903d0000ff2f00'
TRACK2_HEX = '4d54726b00000a4200ff21010000ff031a536f6e61746120517561736920556e612046616e74617369612000b0000000c0000090311d00252500382e2838005038262838005038202838005038212838004f2500003100012f2600232a00381928380050381e28380050381b2838005038252838004f2300002f00012d27002125816f2100002d00012a1d001e1b816f1e00002a00012c1f00382c00202528380050382c2838004f2000002c00012027002c200038252838004f2c00002000013627283600503424002c2100251900311728340000381b28380028382428380050382a28380050382e2838004f2c0000250000310001301c002c2000382b00242828380050382028380050381b2838005038202838004f2400002c000030000138360031220025252838005038172838004f2500003100012a1c001e21816f1e00002a00012f180023250038192838005038192838004f2300002f00012319002f18816f2f0000230001282400341500381928380050381628380050381928380050381b2838004f340000280001282400342100372428370050372228370050371d2837005037292837004f340000280001321300371a00261928370050371928370050371a2837005037222837004f26000032000124200030280037282837004f3000002400012f2800372800232e2837004f2300002f00013734002e2600222528370050362f2836004f2200002e00012322003620002f2828360050361e2836004f2f0000230001373000282b2837004f2800012b2c00342f282b004f3400013627002a2228360050361e773600002a00012a2200361f001e2228360050361b2836004f1e00002a00012f2800232a84572300002f00012834003435773400002800013751002b4d772b00003700013433002822772800003400012f1d00232184082300002f0050342e00283077280000340001374a002b44772b0000370001342f002822772800003400012335002f1f816f2f00002300012c24002020816f2000002c00012922001d27816f1d00002900012a26001e1c816f1e00002a00012326003730002f332837005037302837004f2f0000230001362500242400303128360050361a2836004f300000240001311c00251d28310000361228360028312228310000361d28360027250001311900252528310000361928360000381e27250001380000311700251d28250000310000351f283500003828283800003624001e27002517002a1a28360083371e00002500002a0001352200291d00311b835f3100002900003500012a1f003616816f3600002a0001273800333377330000270001313e002532772500003100012433003033002c2d82672c00003000002400012c25003038002439772400003000002c0001312b002c2e00251c816f2500002c00003100012a1b001e21771e00002a00012b2e001f22771f00002b00012026002c1b835f2c00002000012c2000202728302a28300000332628330000384128302e28300000333827380001330026303a28300002332b283300003632283030283000003323272c00003600002000013300002027002c2500343628340083372c00002000012c2600202a28342228340000381e28380028342c28340000383a28380028342528340000382728380028341d283400003820272000002c0001380000332d00201d002c1928330028363128360082672c00002000012c2100343000202428340028382828380082672000002c00012028002c1b835f2c00002000012020002c228908362b28360028334528362e28360000330000313d283628283600003100272c00002000012c2000202300302c28362328360000382c283800283826283800003630273000013600003347283626283600273300013144283624283600272c00002000003100012025003034002c2028362228360000383f28380028383828380000363527300001360000324828362d283600273200013140283627283600272000002c00003100012c1f00202700303928361928360000383528380028382e283800003632272c00003000002000013600002d26002126003125283418283400273100013120283100003422283400272100002d00011e19002a1b00332828330050332b2833004f2a00001e00012021002c2100332d28330000382d283800283322283300003626283600272c0000200001312200342d002c2500252328340000381b28380028382d28380050381e2838005038192838004f3100002c0000250001241a00301800382e002c1428380050381b2838005038192838005038282838004f2c0000300000240001251400381b00311928380050382e2838004f3100002500012a1e001e23816f1e00002a00012f2300381f0023252838005038222838004f2300002f00012323002f16816f2f0000230001282900342000381428380083373400002800013328002721835f270000330001342400282a816f280000340001273a003339773300002700012539003141773100002500012c2800303c002433816f2400003000002c00012526003124002c2b772c00003100002500792a11001e22816f1e00002a0001201a002c1e816f2c0000200001311900251d84572500003100012a31003630773600002a00012d4f772d00012a1f00361f773600002a0001312200251b8457250000310001362c002a32772a00003600012d48772d00012a2700361e773600002a00012523003119816f3100002500012a1a001e1c816f1e00002a0001272600331d826733000027000128200034187734000028000125250031277731000025000133260027277727000033000124270038260030232838004f30000024000138260031210025242838004f2500003100013630002d2200211d28360050362e2836004f2100002d0001202c002c280038362838004f2c00002000011e2d002a2c772a00001e0001202b00382d002c1f2838005038202838004f2c0000200001360d002023002c1e28360050362a2836004f2c00002000012c1b00342700252128340000382228380028382c2838005038242838004f2c0001382b002c3d283800322c00002c3d1d2500012c00002434002c2e00383328380050382e28380050382c2838004f2c00013838002c40283800322c00002c301d2400012c0000382d002c3700252b283800823f2c00012c455a2c00002c3e1d2500012c0000203c002c3c82672c00002000012c312838242838000036380a2c00002c331e2c0000360000343300252c002c34283400823f2c00002500012c3d5a2c00002c401e2c00002036002c3d82672c00002000012c3828383428380000362f0a2c00002c331e2c00003600002c2e00343100252f28340000382d28380078381e272c0001380000313628341d283400003821283800283828283800003422273100013400002c26283126283100003423272c00013400003833283800003425283400003124283100002c21282c00003124283100002c28282c0000282c282800002c27282c0000282927250001280000252b816f2500012521002c2100311b003422003833816f3800003100002500002c00003400012516003117002c1d003412003826835f3800002c0000250000310000340000ff2f00'
