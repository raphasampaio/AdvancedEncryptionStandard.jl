import AdvancedEncryptionStandard as AES

using Aqua
using Test

function test_aqua()
    @testset "Ambiguities" begin
        Aqua.test_ambiguities(AES, recursive = false)
    end
    Aqua.test_all(AES, ambiguities = false)

    return nothing
end

function test_helpers()
    @test AES.string_to_bytes("YELLOW SUBMARINE") == [
        0x59, 0x45, 0x4c, 0x4c,
        0x4f, 0x57, 0x20, 0x53,
        0x55, 0x42, 0x4d, 0x41,
        0x52, 0x49, 0x4e, 0x45,
    ]

    @test AES.string_to_bytes("PURPLE SIDEKICKS") == [
        0x50, 0x55, 0x52, 0x50,
        0x4c, 0x45, 0x20, 0x53,
        0x49, 0x44, 0x45, 0x4b,
        0x49, 0x43, 0x4b, 0x53,
    ]

    @test AES.vector_uint32_to_string(
        AES.string_to_vector_uint32("YELLOW SUBMARINE"),
    ) == "YELLOW SUBMARINE"

    @test AES.vector_uint32_to_string(
        AES.string_to_vector_uint32("PURPLE SIDEKICKS"),
    ) == "PURPLE SIDEKICKS"

    return nothing
end

function test_sub_word()
    a = [0x8e9ff1c6, 0x4ddce1c7, 0xa158d1c8, 0xbc9dc1c9]
    b = [0x19dba1b4, 0xe386f8c6, 0x326a3ee8, 0x655e78dd]

    for i in eachindex(a)
        @test AES.sub_word(a[i]) == b[i]
        @test AES.inv_sub_word(b[i]) == a[i]
    end

    return nothing
end

function test_sub_bytes()
    a = [0x8e9ff1c6, 0x4ddce1c7, 0xa158d1c8, 0xbc9dc1c9]
    b = [0x19dba1b4, 0xe386f8c6, 0x326a3ee8, 0x655e78dd]

    @test AES.sub_bytes(a) == b
    @test AES.inv_sub_bytes(b) == a

    return nothing
end

function test_shift_rows()
    a = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]
    b = [0x8e9f01c6, 0xdc01c64d, 0x01c6a158, 0xc6bc9d01]

    @test AES.shift_rows(a) == b
    @test AES.inv_shift_rows(b) == a

    return nothing
end

function test_mix_columns()
    a = [0xdbf201c6, 0x130a01c6, 0x532201c6, 0x455c01c6]
    b = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]

    @test AES.mix_columns(a) == b
    @test AES.inv_mix_columns(b) == a

    return nothing
end

function test_add_round_key()
    a = [0x41b9e08b, 0x6e8395a9, 0x18da8b38, 0x990065d0]
    b = [0xe1c1e1c1, 0x21105219, 0x86b4fdb8, 0xf2ca9ec7]
    c = [0xa078014a, 0x4f93c7b0, 0x9e6e7680, 0x6bcafb17]

    @test AES.add_round_key(a, b) == c

    return nothing
end

function test_transpose()
    a = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]
    b = [0x8e4da1bc, 0x9fdc589d, 0x01010101, 0xc6c6c6c6]

    @test AES.transpose(a) == b

    return nothing
end

function test_key_expansion()
    expanded_key = [
        0x594f5552, 0x45574249, 0x4c204d4e, 0x4c534145,
        0x632c792b, 0x6a3d7f36, 0x22024f01, 0x4c1f5e1b,
        0x6448311a, 0x162b5462, 0x8d8fc0c1, 0xbda2fce7,
        0xca82b3a9, 0x6e451173, 0x19965697, 0x1fbd41a6,
        0x4dcf7cd5, 0xe6a3b2c1, 0x3dabfd6a, 0xcc713096,
        0x25ea9643, 0xe447f534, 0xad06fb91, 0xcfbe8e18,
        0x1df76122, 0x6522d7e3, 0x0006fd6c, 0xd56be5fd,
        0x4cbbdaf8, 0x3517c023, 0x5452afc3, 0x462dc835,
        0xea518b73, 0x1b0cccef, 0xc2903ffc, 0x072ae2d7,
        0x2e7ff487, 0xaba76b84, 0xcc5c639f, 0x88a24097,
        0x4738cc4b, 0x70d7bc38, 0x44187be4, 0x9f3d7dea,
    ]

    @test AES.key_expansion("YELLOW SUBMARINE") == expanded_key

    expanded_key = [
        0x504c4949, 0x55454443, 0x5220454b, 0x50534b53,
        0x4b074e07, 0xe6a3e7a4, 0xbf9fda91, 0x6b387320,
        0x0007494e, 0x67c42387, 0x08974ddc, 0xae96e5c5,
        0x13145d13, 0xe1250681, 0xae3974a8, 0x8117f237,
        0x17035e4d, 0x23060081, 0x340d79d1, 0xfceb192e,
        0x0b08561b, 0x1d1b1b9a, 0x050871a0, 0x1ff4edc3,
        0x939bcdd6, 0xfde6fd67, 0x2b2352f2, 0xb044a96a,
        0x56cd00d6, 0x74926f08, 0x290a58aa, 0x4602abc1,
        0xe62b2bfd, 0xd84a252d, 0x515b03a9, 0xb0b219d8,
        0x250e25d8, 0x0b416449, 0x306b68c1, 0xe4564f97,
        0x282603db, 0x7332561f, 0xb8d3bb7a, 0x85d39c0b,
    ]

    @test AES.key_expansion("PURPLE SIDEKICKS") == expanded_key

    return nothing
end

function test_encrypt()
    expanded_key = [
        0x504c4949, 0x55454443, 0x5220454b, 0x50534b53,
        0x4b074e07, 0xe6a3e7a4, 0xbf9fda91, 0x6b387320,
        0x0007494e, 0x67c42387, 0x08974ddc, 0xae96e5c5,
        0x13145d13, 0xe1250681, 0xae3974a8, 0x8117f237,
        0x17035e4d, 0x23060081, 0x340d79d1, 0xfceb192e,
        0x0b08561b, 0x1d1b1b9a, 0x050871a0, 0x1ff4edc3,
        0x939bcdd6, 0xfde6fd67, 0x2b2352f2, 0xb044a96a,
        0x56cd00d6, 0x74926f08, 0x290a58aa, 0x4602abc1,
        0xe62b2bfd, 0xd84a252d, 0x515b03a9, 0xb0b219d8,
        0x250e25d8, 0x0b416449, 0x306b68c1, 0xe4564f97,
        0x282603db, 0x7332561f, 0xb8d3bb7a, 0x85d39c0b,
    ]

    state = [
        0x41052b1a,
        0x7e4da6d6,
        0x3766c538,
        0xa601d2dd,
    ]

    AES.encrypt!(state, expanded_key)

    @test state == [
        0x2449d33c,
        0x59034ddd,
        0xc45e681f,
        0xb349e5f4,
    ]

    AES.decrypt!(state, expanded_key)

    @test state == [
        0x41052b1a,
        0x7e4da6d6,
        0x3766c538,
        0xa601d2dd,
    ]

    return nothing
end

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    @testset "helpers" begin
        test_helpers()
    end

    @testset "sub_word" begin
        test_sub_word()
    end

    @testset "sub_bytes" begin
        test_sub_bytes()
    end

    @testset "shift_rows" begin
        test_shift_rows()
    end

    @testset "mix_columns" begin
        test_mix_columns()
    end

    @testset "add_round_key" begin
        test_add_round_key()
    end

    @testset "transpose" begin
        test_transpose()
    end

    @testset "key_expansion" begin
        test_key_expansion()
    end

    @testset "encrypt" begin
        test_encrypt()
    end

    return nothing
end

test_all()
