# AdvancedEncryptionStandard.jl

[![CI](https://github.com/raphasampaio/AdvancedEncryptionStandard.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/AdvancedEncryptionStandard.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/AdvancedEncryptionStandard.jl/graph/badge.svg?token=FPKzhDwSAB)](https://codecov.io/gh/raphasampaio/AdvancedEncryptionStandard.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Introduction

AdvancedEncryptionStandard.jl is a package that implements the [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) algorithm in Julia. The package is based on the [FIPS PUB 197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf) specification.

## Getting Started

### Installation

```julia
julia> ] add AdvancedEncryptionStandard
```

### Example

```julia
import AdvancedEncryptionStandard as AES

expanded_key = AES.key_expansion("YELLOW SUBMARINE")

plain_text = "Hello World"
state = AES.add_padding(plaintext)

encrypted = AES.encrypt(state, expanded_key)
decrypted = AES.decrypt(encrypted, expanded_key)

decrypted_message = String(AES.remove_padding(decrypted))
```

## Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.
