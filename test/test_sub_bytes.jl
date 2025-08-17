module TestSubBytes

using Test

import AdvancedEncryptionStandard as AES

@testset "SubBytes" begin
    a = [0x8e9ff1c6, 0x4ddce1c7, 0xa158d1c8, 0xbc9dc1c9]
    b = [0x19dba1b4, 0xe386f8c6, 0x326a3ee8, 0x655e78dd]

    @test AES.sub_bytes(a) == b
    @test AES.inv_sub_bytes(b) == a
end
end
