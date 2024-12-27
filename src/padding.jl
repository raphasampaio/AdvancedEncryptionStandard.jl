function add_padding(data::Vector{UInt8}, block_size::Int)
    padlen_bytes = block_size - (sizeof(data) % block_size) 
    padlen_uint32 = ceil(Int, padlen_bytes / 4) 
    padding = fill(UInt32(padlen_bytes), padlen_uint32) 
    data_padded_bytes = [data; fill(UInt8(padlen_bytes), padlen_bytes)]
    data_padded_uint32 = reinterpret(UInt32, data_padded_bytes)
    return data_padded_uint32
end
