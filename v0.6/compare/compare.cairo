%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.default_dict import (default_dict_new, default_dict_finalize)
from starkware.cairo.common.dict import (dict_write, dict_read, dict_update)
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.alloc import alloc

@view
func gate_ports_lookup {range_check_ptr} (gate_idx : felt) -> (vo_net_idx : felt, vi_1_net_idx : felt, vi_2_net_idx : felt):
    if gate_idx == 0:
        return (0,1,2)
    end

    if gate_idx == 1:
        return (3,4,5)
    else:
        return (6,7,8)
    end
end