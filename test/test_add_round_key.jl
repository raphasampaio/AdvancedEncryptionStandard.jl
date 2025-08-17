module TestAddRoundKey

using Test

import AdvancedEncryptionStandard as AES

@testset "Add Round Key" begin
    a = [0x41b9e08b, 0x6e8395a9, 0x18da8b38, 0x990065d0]
    b = [0xe1c1e1c1, 0x21105219, 0x86b4fdb8, 0xf2ca9ec7]
    c = [0xa078014a, 0x4f93c7b0, 0x9e6e7680, 0x6bcafb17]

    @test AES.add_round_key(a, b) == c
end
end
