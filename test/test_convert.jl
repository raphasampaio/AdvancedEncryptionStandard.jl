module TestConvert

using Test

import AdvancedEncryptionStandard as AES

@testset "Convert" begin
    @test AES.to_vector_uint8("YELLOW SUBMARINE") == [
        0x59, 0x45, 0x4c, 0x4c,
        0x4f, 0x57, 0x20, 0x53,
        0x55, 0x42, 0x4d, 0x41,
        0x52, 0x49, 0x4e, 0x45,
    ]

    @test AES.to_vector_uint8("PURPLE SIDEKICKS") == [
        0x50, 0x55, 0x52, 0x50,
        0x4c, 0x45, 0x20, 0x53,
        0x49, 0x44, 0x45, 0x4b,
        0x49, 0x43, 0x4b, 0x53,
    ]

    @test AES.to_string(
        AES.to_vector_uint32("YELLOW SUBMARINE"),
    ) == "YELLOW SUBMARINE"

    @test AES.to_string(
        AES.to_vector_uint32("PURPLE SIDEKICKS"),
    ) == "PURPLE SIDEKICKS"
end

end
