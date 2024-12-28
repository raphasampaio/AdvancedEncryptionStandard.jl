add_padding(data::AbstractString, args...) = add_padding(Vector{UInt8}(data), args...)

# add_padding(data::Vector{UInt32}, args...) = add_padding(to_vector_uint8(data), args...)

function add_padding(data::Vector{UInt8}, block_size::Integer = 16)
    size = block_size - (length(data) % block_size)
    return vcat(data, [UInt8(size) for _ in 1:size])
end

remove_padding(data::Vector{UInt32}) = remove_padding(to_vector_uint8(data))

function remove_padding(data::Vector{UInt8})
    return data[1:end-data[end]]
end
