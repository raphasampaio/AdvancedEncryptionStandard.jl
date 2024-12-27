function Base.hex2bytes(i::UInt32)
    hex = string(i, base = 16)
    return hex2bytes(hex)
end

function string_to_bytes(s::AbstractString)::Vector{UInt8}
    return collect(codeunits(s))
end

function merge_uint8_to_uint32(vec::Vector{UInt8})::Vector{UInt32}
    @assert length(vec) % 4 == 0
    
    result = Vector{UInt32}(undef, length(vec) ÷ 4)
    
    for i in 1:length(result)
        result[i] = (UInt32(vec[4i-3]) << 24) | (UInt32(vec[4i-2]) << 16) | (UInt32(vec[4i-1]) << 8) | UInt32(vec[4i])
    end
    
    return result
end