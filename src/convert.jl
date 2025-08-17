# function to_string(vector::Vector{UInt8})::String
#     return String(vector)
# end

function to_string(vector::Vector{UInt32})::String
    return String(reinterpret(UInt8, vector))
end

function to_vector_uint32(string::AbstractString)::Vector{UInt32}
    @assert length(string) % 4 == 0 "String length must be a multiple of 4 for UInt32 conversion"
    bytes = collect(UInt8, string)
    return reinterpret(UInt32, bytes)
end

function to_vector_uint32(vector::Vector{UInt8})::Vector{UInt32}
    @assert length(vector) % 4 == 0

    result = Vector{UInt32}(undef, length(vector) ÷ 4)

    for i in 1:length(result)
        result[i] =
            (UInt32(vector[4i-3]) << 24) | (UInt32(vector[4i-2]) << 16) | (UInt32(vector[4i-1]) << 8) |
            UInt32(vector[4i])
    end

    return result
end

function to_vector_uint8(string::AbstractString)::Vector{UInt8}
    return collect(UInt8, string)
end

function to_vector_uint8(vec::Vector{UInt32})::Vector{UInt8}
    result = Vector{UInt8}(undef, length(vec) * 4)

    for i in 1:length(vec)
        result[4i-3] = UInt8((vec[i] >> 24) & 0xFF)
        result[4i-2] = UInt8((vec[i] >> 16) & 0xFF)
        result[4i-1] = UInt8((vec[i] >> 8) & 0xFF)
        result[4i] = UInt8(vec[i] & 0xFF)
    end

    return result
end
