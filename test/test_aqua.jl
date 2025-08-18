module TestAqua

using Aqua
using Test

import AdvancedEncryptionStandard as AES

@testset "Aqua" begin
    Aqua.test_ambiguities(AES, recursive = false)
    Aqua.test_all(AES, ambiguities = false)
    return nothing
end

end
