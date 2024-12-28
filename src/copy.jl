function sub_bytes(state::Vector{UInt32})
    state_copy = copy(state)
    sub_bytes!(state_copy)
    return state_copy
end

function inv_sub_bytes(state::Vector{UInt32})
    state_copy = copy(state)
    inv_sub_bytes!(state_copy)
    return state_copy
end

function shift_rows(state::Vector{UInt32})
    state_copy = copy(state)
    shift_rows!(state_copy)
    return state_copy
end

function inv_shift_rows(state::Vector{UInt32})
    state_copy = copy(state)
    inv_shift_rows!(state_copy)
    return state_copy
end

function mix_columns(state::Vector{UInt32})
    state_copy = copy(state)
    mix_columns!(state_copy)
    return state_copy
end

function inv_mix_columns(state::Vector{UInt32})
    state_copy = copy(state)
    inv_mix_columns!(state_copy)
    return state_copy
end

function add_round_key(state::Vector{UInt32}, round_key::Vector{UInt32})
    state_copy = copy(state)
    add_round_key!(state_copy, round_key)
    return state_copy
end

function encrypt(state::Vector{UInt8}, expanded_key::Vector{UInt32})
    state_copy = to_vector_uint32(state)
    encrypt!(state_copy, expanded_key)
    return state_copy
end

function encrypt(state::Vector{UInt32}, expanded_key::Vector{UInt32})
    state_copy = copy(state)
    encrypt!(state_copy, expanded_key)
    return state_copy
end

# function decrypt(state::Vector{UInt8}, expanded_key::Vector{UInt32})
#     state_copy = to_vector_uint32(state)
#     decrypt!(state_copy, expanded_key)
#     return state_copy
# end

function decrypt(state::Vector{UInt32}, expanded_key::Vector{UInt32})
    state_copy = copy(state)
    decrypt!(state_copy, expanded_key)
    return state_copy
end
