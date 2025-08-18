module TestTranspose

using Test

import AdvancedEncryptionStandard as AES

@testset "Transpose" begin
    a = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]
    b = [0x8e4da1bc, 0x9fdc589d, 0x01010101, 0xc6c6c6c6]

    @test AES.transpose(a) == b
end
end
