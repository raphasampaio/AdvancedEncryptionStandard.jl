module TestShiftRows

using Test

import AdvancedEncryptionStandard as AES

@testset "Shift Rows" begin
    a = [0x8e9f01c6, 0x4ddc01c6, 0xa15801c6, 0xbc9d01c6]
    b = [0x8e9f01c6, 0xdc01c64d, 0x01c6a158, 0xc6bc9d01]

    @test AES.shift_rows(a) == b
    @test AES.inv_shift_rows(b) == a

end
end