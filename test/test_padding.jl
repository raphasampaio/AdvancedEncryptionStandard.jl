module TestPadding

using Test

import AdvancedEncryptionStandard as AES

@testset "Padding" begin
    @test "Hello World" == String(AES.remove_padding(AES.add_padding("Hello World")))
end
end