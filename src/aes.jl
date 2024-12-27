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

rot_word_left(input::UInt32, n::Integer) = rot_word_left(input, UInt32(n))

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

function key_expansion(key::Vector{UInt8})::Vector{UInt32}
    nwords = 4
    rounds = 10
    size = 4 * (rounds + 1)

    expanded_key = Vector{UInt32}(undef, size)

    for i in 1:nwords
        k1 = UInt32(key[(i-1)*4+1]) << 24
        k2 = UInt32(key[(i-1)*4+2]) << 16
        k3 = UInt32(key[(i-1)*4+3]) << 8
        k4 = UInt32(key[(i-1)*4+4])

        expanded_key[i] = k1 | k2 | k3 | k4
    end

    for i in nwords+1:nwords:size
        temp = expanded_key[i-1]
        temp = rot_word_left(temp, 1)
        temp = sub_word(temp)
        temp = temp ⊻ rcon((i - 1) ÷ nwords - 1)
        expanded_key[i] = temp ⊻ expanded_key[i-nwords]

        for j in 1:3
            expanded_key[i+j] = expanded_key[i+j-1] ⊻ expanded_key[i+j-nwords]
        end
    end

    for i in 1:nwords:size
        transposed = transpose(expanded_key[i:i+3])
        expanded_key[i] = transposed[1]
        expanded_key[i+1] = transposed[2]
        expanded_key[i+2] = transposed[3]
        expanded_key[i+3] = transposed[4]
    end

    return expanded_key
end

function encrypt!(state::Vector{UInt32}, expanded_key::Vector{UInt32})
    keyi = 1
    add_round_key!(state, expanded_key[keyi:keyi+3])
    keyi += 4
    rounds = length(expanded_key) ÷ 4 - 2

    for _ in 1:rounds
        sub_bytes!(state)
        shift_rows!(state)
        mix_columns!(state)
        add_round_key!(state, expanded_key[keyi:keyi+3])
        keyi += 4
    end

    sub_bytes!(state)
    shift_rows!(state)
    add_round_key!(state, expanded_key[keyi:keyi+3])

    return nothing
end

function decrypt!(state::Vector{UInt32}, expanded_key::Vector{UInt32})
    keyi = length(expanded_key) - 3
    add_round_key!(state, expanded_key[keyi:keyi+3])
    keyi -= 4
    rounds = length(expanded_key) ÷ 4 - 2

    for _ in 1:rounds
        inv_shift_rows!(state)
        inv_sub_bytes!(state)
        add_round_key!(state, expanded_key[keyi:keyi+3])
        keyi -= 4
        inv_mix_columns!(state)
    end

    inv_shift_rows!(state)
    inv_sub_bytes!(state)
    @show keyi
    add_round_key!(state, expanded_key[keyi:keyi+3])

    return nothing
end

# encrypt(text::AbstractString, expkey::Vector{UInt32}) = encrypt(hex2bytes(text), expkey)
