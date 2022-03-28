%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.math import assert_lt

# set - Adds a key-value pair to a map, or updates the value for an existing key. O(1).
# remove - Removes a value from a set. O(1).
# length - Returns the number of elements in the map. O(1).
# at - Returns the element stored at position index in the set. O(1).
# get - Returns the value associated with key.  O(1).

struct EnumerableTaskMap_Struct:
    member foo : felt
    member bar : felt
end

@storage_var
func EnumerableTaskMap_keyValueMap(key : felt) -> (value : EnumerableTaskMap_Struct):
end

@storage_var
func EnumerableTaskMap_keyExists(key : felt) -> (exists : felt):
end

@storage_var
func EnumerableTaskMap_length() -> (length : felt):
end

@storage_var
func EnumerableTaskMap_indexKeyMap(index : felt) -> (key : felt):
end

@storage_var
func EnumerableTaskMap_keyIndexMap(key : felt) -> (index : felt):
end

func EnumerableTaskMap_set{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt, value : EnumerableTaskMap_Struct) -> (task : EnumerableTaskMap_Struct):
    alloc_locals
    # assign value to the key
    EnumerableTaskMap_keyValueMap.write(key, value)

    let (exists) = EnumerableTaskMap_keyExists.read(key)

    # are we dealing with a new key?
    if exists == 1:
        return EnumerableTaskMap_keyValueMap.read(key)
    end

    # find index for the key
    let (oldLength) = EnumerableTaskMap_length.read()

    EnumerableTaskMap_length.write(oldLength + 1)

    # keep track of key and index relationship
    EnumerableTaskMap_indexKeyMap.write(oldLength, key)
    EnumerableTaskMap_keyIndexMap.write(key, oldLength)
    EnumerableTaskMap_keyExists.write(key, 1)

    return EnumerableTaskMap_keyValueMap.read(key)
end

func EnumerableTaskMap_removeByIndex{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        indexToRemove : felt) -> (removed : felt):
    alloc_locals

    let (oldLength) = EnumerableTaskMap_length.read()

    # does the index we are trying to remove exist?
    let (indexExists) = is_le(indexToRemove, oldLength - 1)
    if indexExists == 0:
        return (0)
    end

    # find key to remove
    let (keyToRemove) = EnumerableTaskMap_indexKeyMap.read(indexToRemove)

    # find last key in our array that will be moved at #indexToRemove position
    let (keyToRelocate) = EnumerableTaskMap_indexKeyMap.read(oldLength - 1)

    # delete key
    EnumerableTaskMap_keyExists.write(keyToRemove, 0)

    # delete value
    EnumerableTaskMap_keyValueMap.write(keyToRemove, EnumerableTaskMap_Struct(0, 0))

    # replace #indexToRemove position with previously last array element
    EnumerableTaskMap_indexKeyMap.write(indexToRemove, keyToRelocate)

    # remove indexKey's last entry
    EnumerableTaskMap_indexKeyMap.write(oldLength - 1, 0)

    # decrease length
    EnumerableTaskMap_length.write(oldLength - 1)
    return (1)
end

func EnumerableTaskMap_remove{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt) -> (removed : felt):
    # does the key we are trying to remove exist?
    let (doesKeyExist) = EnumerableTaskMap_keyExists.read(key)
    if doesKeyExist == 0:
        return (0)
    end

    # find index to remove
    let (index) = EnumerableTaskMap_keyIndexMap.read(key)
    EnumerableTaskMap_removeByIndex(index)
    return (1)
end

func EnumerableTaskMap_at{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        index : felt) -> (value : EnumerableTaskMap_Struct):
    let (key) = EnumerableTaskMap_indexKeyMap.read(index)
    return EnumerableTaskMap_keyValueMap.read(key)
end

func EnumerableTaskMap_get{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt) -> (value : EnumerableTaskMap_Struct):
    alloc_locals
    let (doesKeyExist) = EnumerableTaskMap_keyExists.read(key)
    with_attr error_message("key does not exist"):
        assert_lt(0, doesKeyExist)
    end
    return EnumerableTaskMap_keyValueMap.read(key)
end

func EnumerableTaskMap_tryGet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        key : felt) -> (value : EnumerableTaskMap_Struct):
    return EnumerableTaskMap_keyValueMap.read(key)
end

func EnumerableTaskMap_populate_array{
        syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        array_ptr_len : felt, array_ptr : EnumerableTaskMap_Struct*, index : felt):
    let (shouldStop) = is_le(array_ptr_len, index)
    if shouldStop == 1:
        return ()
    end
    let (key) = EnumerableTaskMap_indexKeyMap.read(index)
    let (value) = EnumerableTaskMap_keyValueMap.read(key)
    assert array_ptr[index] = value
    EnumerableTaskMap_populate_array(array_ptr_len, array_ptr, index + 1)
    return ()
end

func EnumerableTaskMap_list{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        ) -> (tasks_len : felt, tasks : EnumerableTaskMap_Struct*):
    alloc_locals
    let (size : felt) = EnumerableTaskMap_length.read()
    let (array_ptr : EnumerableTaskMap_Struct*) = alloc()
    EnumerableTaskMap_populate_array(size, array_ptr, 0)
    return (size, array_ptr)
end

