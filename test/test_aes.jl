function test_key_expansion()
    key = "YELLOW SUBMARINE"
    expandedkey = [0x594f5552, 0x45574249, 0x4c204d4e, 0x4c534145, 0x632c792b,
        0x6a3d7f36, 0x22024f01, 0x4c1f5e1b, 0x6448311a, 0x162b5462, 0x8d8fc0c1, 0xbda2fce7,
        0xca82b3a9, 0x6e451173, 0x19965697, 0x1fbd41a6, 0x4dcf7cd5, 0xe6a3b2c1, 0x3dabfd6a,
        0xcc713096, 0x25ea9643, 0xe447f534, 0xad06fb91, 0xcfbe8e18, 0x1df76122, 0x6522d7e3,
        0x6fd6c, 0xd56be5fd, 0x4cbbdaf8, 0x3517c023, 0x5452afc3, 0x462dc835, 0xea518b73,
        0x1b0cccef, 0xc2903ffc, 0x72ae2d7, 0x2e7ff487, 0xaba76b84, 0xcc5c639f, 0x88a24097,
        0x4738cc4b, 0x70d7bc38, 0x44187be4, 0x9f3d7dea]

    @show actual = Locksmith.AES.key_expansion(key)

    @test expandedkey == actual

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
    a = [0x8e9ff1c6, 0x4ddce1c7, 0xa158d1c8, 0xbc9dc1c9]
    b = [0x19dba1b4, 0xe386f8c6, 0x326a3ee8, 0x655e78dd]

    for i in eachindex(a)
        @test Locksmith.AES.sub_word(a[i]) == b[i]
        @test Locksmith.AES.inv_sub_word(b[i]) == a[i]
    end

    @test Locksmith.AES.sub_bytes(a) == b
    @test Locksmith.AES.inv_sub_bytes(b) == a

    a = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]
    b = [0x8e9f01c6, 0xdc01c64d, 0x01c6a158, 0xc6bc9d01]

    @test Locksmith.AES.shift_rows(a) == b
    @test Locksmith.AES.inv_shift_rows(b) == a

    a = [0xdbf201c6, 0x130a01c6, 0x532201c6, 0x455c01c6]
    b = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]

    @test Locksmith.AES.mix_columns(a) == b
    @test Locksmith.AES.inv_mix_columns(b) == a

    # key = "PURPLE SIDEKICKS"
	# expkey = [0x594f5552, 0x45574249, 0x4c204d4e, 0x4c534145, 0x632c792b,
    # 0x6a3d7f36, 0x22024f01, 0x4c1f5e1b, 0x6448311a, 0x162b5462, 0x8d8fc0c1, 0xbda2fce7,
    # 0xca82b3a9, 0x6e451173, 0x19965697, 0x1fbd41a6, 0x4dcf7cd5, 0xe6a3b2c1, 0x3dabfd6a,
    # 0xcc713096, 0x25ea9643, 0xe447f534, 0xad06fb91, 0xcfbe8e18, 0x1df76122, 0x6522d7e3,
    # 0x6fd6c, 0xd56be5fd, 0x4cbbdaf8, 0x3517c023, 0x5452afc3, 0x462dc835, 0xea518b73,
    # 0x1b0cccef, 0xc2903ffc, 0x72ae2d7, 0x2e7ff487, 0xaba76b84, 0xcc5c639f, 0x88a24097,
    # 0x4738cc4b, 0x70d7bc38, 0x44187be4, 0x9f3d7dea]
	# @show Locksmith.AES.encrypt(key, expkey)

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
    # @test Locksmith.AES.encrypt(plain1, key1) == cipher1
    # @test Locksmith.AES.encrypt(plain2, key2) == cipher2
    # @test Locksmith.AES.encrypt(plain3, key3) == cipher3

    return nothing
end
