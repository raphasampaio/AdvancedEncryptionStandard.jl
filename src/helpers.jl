# function Base.hex2bytes(i::UInt32)
#     hex = string(i, base = 16)
#     return hex2bytes(hex)
# end

function string_to_bytes(string::AbstractString)::Vector{UInt8}
    return collect(UInt8, string)
end

function string_to_vector_uint32(string::AbstractString)::Vector{UInt32}
    @assert length(string) % 4 == 0 "String length must be a multiple of 4 for UInt32 conversion"
    bytes = collect(UInt8, string)
    return reinterpret(UInt32, bytes)
end

function vector_uint32_to_string(vector::Vector{UInt32})::String
    return String(reinterpret(UInt8, vector))
end

function pack(vec::Vector{UInt8})::Vector{UInt32}
    @assert length(vec) % 4 == 0

    result = Vector{UInt32}(undef, length(vec) ÷ 4)

    for i in 1:length(result)
        result[i] = (UInt32(vec[4i-3]) << 24) | (UInt32(vec[4i-2]) << 16) | (UInt32(vec[4i-1]) << 8) | UInt32(vec[4i])
    end

    return result
end

function unpack(vec::Vector{UInt32})::Vector{UInt8}
    result = Vector{UInt8}(undef, length(vec) * 4)

    for i in 1:length(vec)
        result[4i-3] = UInt8(vec[i] >> 24)
        result[4i-2] = UInt8(vec[i] >> 16)
        result[4i-1] = UInt8(vec[i] >> 8)
        result[4i] = UInt8(vec[i])
    end

    return result
end
