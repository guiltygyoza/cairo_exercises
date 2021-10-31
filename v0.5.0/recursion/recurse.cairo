%lang starknet
%builtins range_check

@external
func run_simulation {
        range_check_ptr
    } (start_pos : felt) -> (total_reward : felt):

    let (final_pos, total_reward) = _recurse_forward (start_pos)
    assert final_pos = 0

    return (total_reward)
end

@external
func run_simulation_countsteps {
        range_check_ptr
    } (start_pos : felt) -> (steps_took : felt, total_reward : felt):

    let (final_pos, steps_took, total_reward) = _recurse_forward_countsteps (start_pos)
    assert final_pos = 0

    return (steps_took, total_reward)
end

@external
func run_simulation_countsteps_capped {
        range_check_ptr
    } (start_pos : felt, iter_cap : felt) -> (steps_took : felt, total_reward : felt, final_bool_stopped : felt):

    let (final_pos, steps_took, total_reward, final_bool_stopped) = _recurse_forward_countsteps_capped (start_pos, 0, iter_cap, 0)

    return (steps_took, total_reward, final_bool_stopped)
end

####################################################

func _recurse_forward {
        range_check_ptr
    } (pos : felt) -> (final_pos : felt, reward : felt):
    alloc_locals

    # 1. calculate forward
    let (local pos_, local reward_) = _forward (pos)

    # 2. return if stopping condition reached
    if pos_ == 0:
        return (pos_, reward_)
    end

    # 3. otherwise, recurse
    let (final_pos, rest_of_reward) = _recurse_forward (pos_)

    # 4. return rolling sum of rewards
    return (final_pos, rest_of_reward + reward_)
end


func _recurse_forward_countsteps {
        range_check_ptr
    } (pos : felt) -> (final_pos : felt, steps : felt, reward : felt):
    alloc_locals

    # 1. calculate forward
    let (local pos_, local reward_) = _forward (pos)

    # 2. return if stopping condition reached
    if pos_ == 0:
        return (pos_, 1, reward_)
    end

    # 3. otherwise, recurse
    let (final_pos, rest_of_steps, rest_of_reward) = _recurse_forward_countsteps (pos_)

    # 4. return rolling sum of rewards
    return (final_pos, rest_of_steps + 1, rest_of_reward + reward_)
end

func _recurse_forward_countsteps_capped {
        range_check_ptr
    } (
        pos : felt, iter : felt, iter_cap : felt, bool_stopped : felt
    ) -> (
        final_pos : felt, steps : felt, reward : felt, bool_stopped : felt
    ):
    alloc_locals

    # 1. calculate forward
    let (local pos_, local reward_) = _forward (pos)

    # 2. return if stopping condition reached
    local bool_stopped
    if pos_ == 0:
        assert bool_stopped = 1
        return (pos_, 1, reward_, bool_stopped)
    else:
        # 3. check if reach recursion cap (preparing for simulation pipelining within starknet execution resource limit per tx)
        assert bool_stopped = 0
        local iter_ = iter + 1
        tempvar iter_left = iter_cap - iter_
        if iter_left == 0:
            return (pos_, 1, reward_, bool_stopped)
        end
    end

    # 4. all good? recurse
    let (final_pos, rest_of_steps, rest_of_reward, final_bool_stopped) = _recurse_forward_countsteps_capped (pos_, iter_, iter_cap, bool_stopped)

    # 5. return rolling sum of rewards
    return (final_pos, rest_of_steps + 1, rest_of_reward + reward_, final_bool_stopped)
end

func _forward {
        range_check_ptr
    } (pos)->(pos_, reward_):

    let pos_ = pos - 1
    let reward_ = 5

    return(pos_, reward_)
end