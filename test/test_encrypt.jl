module TestEncrypt

using Test

import AdvancedEncryptionStandard as AES

@testset "Encrypt" begin
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

    decrypted_state = [
        0x41052b1a,
        0x7e4da6d6,
        0x3766c538,
        0xa601d2dd,
    ]

    encrypted_state = AES.encrypt(decrypted_state, expanded_key)

    @test encrypted_state == [
        0x2449d33c,
        0x59034ddd,
        0xc45e681f,
        0xb349e5f4,
    ]

    @test decrypted_state == AES.decrypt(encrypted_state, expanded_key)

    encrypted_state = AES.encrypt(AES.add_padding("Hello World"), expanded_key)
    @test encrypted_state == [0x9bb0e461, 0x0aea8fe5, 0x562c6dbc, 0x92da2254]
    @test String(AES.remove_padding(AES.decrypt(encrypted_state, expanded_key))) == "Hello World"

end
end