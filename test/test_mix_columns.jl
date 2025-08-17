module TestMixColumns

using Test

import AdvancedEncryptionStandard as AES

@testset "Mix Columns" begin
    a = [0xdbf201c6, 0x130a01c6, 0x532201c6, 0x455c01c6]
    b = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]

    @test AES.mix_columns(a) == b
    @test AES.inv_mix_columns(b) == a
end
end
