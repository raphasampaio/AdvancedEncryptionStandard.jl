module TestSubWord

using Test

import AdvancedEncryptionStandard as AES

@testset "SubWord" begin
    a = [0x8e9ff1c6, 0x4ddce1c7, 0xa158d1c8, 0xbc9dc1c9]
    b = [0x19dba1b4, 0xe386f8c6, 0x326a3ee8, 0x655e78dd]

    for i in eachindex(a)
        @test AES.sub_word(a[i]) == b[i]
        @test AES.inv_sub_word(b[i]) == a[i]
    end
end
end