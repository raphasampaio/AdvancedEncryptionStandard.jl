
function manipulate_columns!(state::Vector{UInt32}, calc::Function)
    for i in 0:3
        a0 = UInt8((state[1] >> (i * 8)) & 0xff)
        a1 = UInt8((state[2] >> (i * 8)) & 0xff)
        a2 = UInt8((state[3] >> (i * 8)) & 0xff)
        a3 = UInt8((state[4] >> (i * 8)) & 0xff)

        r0, r1, r2, r3 = calc(a0, a1, a2, a3)

        mask = ~(UInt32(0xff) << (i * 8))

        state[1] = (state[1] & mask) | (UInt32(r0) << (i * 8))
        state[2] = (state[2] & mask) | (UInt32(r1) << (i * 8))
        state[3] = (state[3] & mask) | (UInt32(r2) << (i * 8))
        state[4] = (state[4] & mask) | (UInt32(r3) << (i * 8))
    end

    return nothing
end

function mix_columns!(state::Vector{UInt32})
    manipulate_columns!(state, calc_mix_cols)
    return nothing
end

function inv_mix_columns!(state::Vector{UInt32})
    manipulate_columns!(state, calc_inv_mix_cols)
    return nothing
end

function add_round_key!(state::Vector{UInt32}, round_key::Vector{UInt32})
    for i in 1:length(state)
        state[i] = state[i] ⊻ round_key[i]
    end
    return nothing
end

function rcon(i::Int)::UInt32
    return UInt32(RCON[i+1]) << 24
end

function transpose!(arr::Vector{UInt32})
    for i in 1:4
        arr[i] = (arr[i] & 0xFF000000) >> 24 | (arr[i] & 0x00FF0000) >> 8 | (arr[i] & 0x0000FF00) << 8 | (arr[i] & 0x000000FF) << 24
    end
end

key_expansion(key::AbstractString) = key_expansion(string_to_bytes(key))

function key_expansion(key::Vector{UInt8})::Vector{UInt32}
    nwords = 4
    rounds = 10

    expkeys = Vector{UInt32}(undef, 4 * (rounds + 1))

    # Copy the original key into the first part of the expanded key
    for i in 1:nwords
        expkeys[i] = UInt32(key[(i-1)*4+1]) << 24 | UInt32(key[(i-1)*4+2]) << 16 | UInt32(key[(i-1)*4+3]) << 8 | UInt32(key[(i-1)*4+4])
    end

    for i in nwords+1:4*(rounds+1)
        temp = expkeys[i-1]
        if mod(i, nwords) == 1
            temp = rot_word_left(temp, UInt32(1))
            temp = sub_word(temp)
            temp = temp ⊻ rcon(div(i, nwords) - 1)
        end
        expkeys[i] = expkeys[i-nwords] ⊻ temp
    end

    for j in 1:4:length(expkeys)
        transpose!(expkeys[j:j+3])
    end

    return expkeys
end

function encrypt!(state::Vector{UInt32}, expkey::Vector{UInt32})
    keyi = 1
    add_round_key(state, expkey[keyi:keyi+3])
    keyi += 4
    rounds = length(expkey) ÷ 4 - 2

    for i in 1:rounds
        sub_bytes(state)
        shift_rows(state)
        mix_columns(state)
        add_round_key(state, expkey[keyi:keyi+3])
        keyi += 4
    end

    sub_bytes(state)
    shift_rows(state)
    add_round_key(state, expkey[keyi:keyi+3])

    return nothing
end

encrypt(text::AbstractString, expkey::Vector{UInt32}) = encrypt(hex2bytes(text), expkey)
