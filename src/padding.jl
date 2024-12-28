add_padding(data::AbstractString, args...) = add_padding(to_vector_uint32(data), args...)

add_padding(data::Vector{UInt32}, args...) = add_padding(to_vector_uint8(data), args...)

function add_padding(data::Vector{UInt8}, block_size::Integer = 16)
    padlen = block_size - (sizeof(data) % block_size)
    return [data; map(i -> UInt8(padlen), 1:padlen)]
end

remove_padding(data::AbstractString) = remove_padding(to_vector_uint32(data))

remove_padding(data::Vector{UInt32}) = remove_padding(to_vector_uint8(data))

function remove_padding(data::Vector{UInt8})
    padlen = data[end]
    if all(data[end-padlen+1:end-1] .== data[end])
        return data[1:end-padlen]
    else
        throw(ArgumentError("Invalid PKCS5 padding"))
    end
end