function Base.hex2bytes(i::UInt32)
    hex = string(i, base = 16)
    return hex2bytes(hex)
end

function string_to_bytes(s::AbstractString)::Vector{UInt8}
    return collect(codeunits(s))
end

function sub_word(input::UInt32)::UInt32
    b0 = UInt32(SBOX[(input>>24)&0xff+1])
    b1 = UInt32(SBOX[(input>>16)&0xff+1])
    b2 = UInt32(SBOX[(input>>8)&0xff+1])
    b3 = UInt32(SBOX[input&0xff+1])
    return (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
end

function inv_sub_word(input::UInt32)::UInt32
    b0 = UInt32(INV_SBOX[(input>>24)&0xff+1])
    b1 = UInt32(INV_SBOX[(input>>16)&0xff+1])
    b2 = UInt32(INV_SBOX[(input>>8)&0xff+1])
    b3 = UInt32(INV_SBOX[input&0xff+1])
    return (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
end

function sub_bytes!(state::Vector{UInt32})
    for i in 1:length(state)
        state[i] = sub_word(state[i])
    end
    return nothing
end

function inv_sub_bytes!(state::Vector{UInt32})
    for i in 1:length(state)
        state[i] = inv_sub_word(state[i])
    end
    return nothing
end

function rot_word_left(input::UInt32, n::UInt32)::UInt32
    return input >> (32 - 8 * n) | input << (8 * n)
end

function rot_word_right(input::UInt32, n::UInt32)::UInt32
    return input << (32 - 8 * n) | input >> (8 * n)
end

function shift_rows!(state::Vector{UInt32})
    for i in 1:4
        state[i] = rot_word_left(state[i], UInt32(i - 1))
    end
    return nothing
end

function inv_shift_rows!(state::Vector{UInt32})
    for i in 1:4
        state[i] = rot_word_right(state[i], UInt32(i - 1))
    end
    return nothing
end

function calc_mix_cols(a0::UInt8, a1::UInt8, a2::UInt8, a3::UInt8)
    r0 = GMULBY2[a0+1] ⊻ GMULBY3[a1+1] ⊻ a2 ⊻ a3
    r1 = a0 ⊻ GMULBY2[a1+1] ⊻ GMULBY3[a2+1] ⊻ a3
    r2 = a0 ⊻ a1 ⊻ GMULBY2[a2+1] ⊻ GMULBY3[a3+1]
    r3 = GMULBY3[a0+1] ⊻ a1 ⊻ a2 ⊻ GMULBY2[a3+1]
    return r0, r1, r2, r3
end

function calc_inv_mix_cols(a0::UInt8, a1::UInt8, a2::UInt8, a3::UInt8)
    r0 = GMULBY14[a0+1] ⊻ GMULBY11[a1+1] ⊻ GMULBY13[a2+1] ⊻ GMULBY9[a3+1]
    r1 = GMULBY9[a0+1] ⊻ GMULBY14[a1+1] ⊻ GMULBY11[a2+1] ⊻ GMULBY13[a3+1]
    r2 = GMULBY13[a0+1] ⊻ GMULBY9[a1+1] ⊻ GMULBY14[a2+1] ⊻ GMULBY11[a3+1]
    r3 = GMULBY11[a0+1] ⊻ GMULBY13[a1+1] ⊻ GMULBY9[a2+1] ⊻ GMULBY14[a3+1]
    return r0, r1, r2, r3
end

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

function transpose(input::Vector{UInt32})
    c0, c1, c2, c3 = UInt32(0), UInt32(0), UInt32(0), UInt32(0)
    for i in 0:3
        c0 |= (input[i+1] >> 24) << (8 * (3 - i))
        c1 |= (input[i+1] >> 16 & 0xff) << (8 * (3 - i))
        c2 |= (input[i+1] >> 8 & 0xff) << (8 * (3 - i))
        c3 |= (input[i+1] & 0xff) << (8 * (3 - i))
    end
    return [c0, c1, c2, c3]
end

function rcon(i::Int)::UInt32
    return UInt32(RCON[i+1]) << 24
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

# encrypt(text::AbstractString, expkey::Vector{UInt32}) = encrypt(hex2bytes(text), expkey)
