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

    key = [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0xcf, 0x9d, 0x5b, 0x6d, 0x3e, 0x11]
    
    expkeys = AES.key_expansion(key)
    
    # Check the length of the expanded key
    @test length(expkeys) == 44
    
    # Check the first 4 words of the expanded key (same as input key)
    @test expkeys[1:4] == [0x2b7e1516, 0x28aed2a6, 0xabf7cf9d, 0x5b6d3e11]

    # Check some known values in the expanded key
    @test expkeys[5] == 0xf2c295f2
    @test expkeys[10] == 0x9ba35411
    @test expkeys[44] == 0xd014f9a8
    
    # Additional checks can be added here

    # a = "YELLOW SUBMARINE"
    # b = [0x594f5552, 0x45574249, 0x4c204d4e, 0x4c534145, 0x632c792b,
    #     0x6a3d7f36, 0x22024f01, 0x4c1f5e1b, 0x6448311a, 0x162b5462, 0x8d8fc0c1, 0xbda2fce7,
    #     0xca82b3a9, 0x6e451173, 0x19965697, 0x1fbd41a6, 0x4dcf7cd5, 0xe6a3b2c1, 0x3dabfd6a,
    #     0xcc713096, 0x25ea9643, 0xe447f534, 0xad06fb91, 0xcfbe8e18, 0x1df76122, 0x6522d7e3,
    #     0x6fd6c, 0xd56be5fd, 0x4cbbdaf8, 0x3517c023, 0x5452afc3, 0x462dc835, 0xea518b73,
    #     0x1b0cccef, 0xc2903ffc, 0x72ae2d7, 0x2e7ff487, 0xaba76b84, 0xcc5c639f, 0x88a24097,
    #     0x4738cc4b, 0x70d7bc38, 0x44187be4, 0x9f3d7dea]

    # @show c = AES.key_expansion(a)

    # @test c == b

    # Nks = [4, 6, 8]
    # Nbs = [4, 4, 4]
    # Nb = 4
    # Nrs = [10, 12, 14]
    # WORDLENGTH = 4

    #     keyunexp1 = 
    #     keyexp1 = AES.KeyExpansion(keyunexp1, Nks[1], Nrs[1])
    #     keyexp1expect = "2b7e151628aed2a6abf7158809cf4f3ca0fafe1788542cb123a339392a6c7605f2c295f27a96b9435935807a7359f67f3d80477d4716fe3e1e237e446d7a883bef44a541a8525b7fb671253bdb0bad00d4d1c6f87c839d87caf2b8bc11f915bc6d88a37a110b3efddbf98641ca0093fd4e54f70e5f5fc9f384a64fb24ea6dc4fead27321b58dbad2312bf5607f8d292fac7766f319fadc2128d12941575c006ed014f9a8c9ee2589e13f0cc8b6630ca6"

    return nothing
end


function test_aes()
    return nothing
end

function test_all()
    # @testset "Aqua.jl" begin test_aqua() end

    # @testset "sub_word" begin test_sub_word() end

    # @testset "sub_bytes" begin test_sub_bytes() end

    # @testset "shift_rows" begin test_shift_rows() end

    # @testset "mix_columns" begin test_mix_columns() end

    # @testset "add_round_key" begin test_add_round_key() end

    # @testset "transpose" begin test_transpose() end

    @testset "key_expansion" begin test_key_expansion() end

    # key = "PURPLE SIDEKICKS"
    # expkey = [0x594f5552, 0x45574249, 0x4c204d4e, 0x4c534145, 0x632c792b,
    # 0x6a3d7f36, 0x22024f01, 0x4c1f5e1b, 0x6448311a, 0x162b5462, 0x8d8fc0c1, 0xbda2fce7,
    # 0xca82b3a9, 0x6e451173, 0x19965697, 0x1fbd41a6, 0x4dcf7cd5, 0xe6a3b2c1, 0x3dabfd6a,
    # 0xcc713096, 0x25ea9643, 0xe447f534, 0xad06fb91, 0xcfbe8e18, 0x1df76122, 0x6522d7e3,
    # 0x6fd6c, 0xd56be5fd, 0x4cbbdaf8, 0x3517c023, 0x5452afc3, 0x462dc835, 0xea518b73,
    # 0x1b0cccef, 0xc2903ffc, 0x72ae2d7, 0x2e7ff487, 0xaba76b84, 0xcc5c639f, 0x88a24097,
    # 0x4738cc4b, 0x70d7bc38, 0x44187be4, 0x9f3d7dea]
    # @show AES.encrypt(key, expkey)

    #     # AES-128
    # const key1 =    "2b7e151628aed2a6abf7158809cf4f3c"
    # const plain1 =  "6bc1bee22e409f96e93d7e117393172a"
    # const cipher1 = "3ad77bb40d7a3660a89ecaf32466ef97"

    # # AES-192
    # const key2 =    "8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b"
    # const plain2 =  "6bc1bee22e409f96e93d7e117393172a"
    # const cipher2 = "bd334f1d6e45f25ff712a214571fa5cc"

    # # AES-256
    # const key3 =    "603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4"
    # const plain3 =  "6bc1bee22e409f96e93d7e117393172a"
    # const cipher3 = "f3eed1bdb5d2a03c064b5a7e3db181f8"

    # # Encryption tests
    # @test AES.encrypt(plain1, key1) == cipher1
    # @test AES.encrypt(plain2, key2) == cipher2
    # @test AES.encrypt(plain3, key3) == cipher3

    return nothing
end

test_all()
