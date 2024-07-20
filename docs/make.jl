using Documenter
using AdvancedEncryptionStandard

DocMeta.setdocmeta!(AdvancedEncryptionStandard, :DocTestSetup, :(using AdvancedEncryptionStandard); recursive = true)

makedocs(
    sitename = "AdvancedEncryptionStandard",
    modules = [AdvancedEncryptionStandard],
    authors = "Raphael Araujo Sampaio",
    repo = "https://github.com/raphasampaio/AdvancedEncryptionStandard.jl/blob/{commit}{path}#{line}",
    doctest = true,
    clean = true,
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://raphasampaio.github.io/AdvancedEncryptionStandard.jl",
        edit_link = "main",
        assets = [
            "assets/favicon.ico",
        ],
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/raphasampaio/AdvancedEncryptionStandard.jl.git",
    devbranch = "main",
    push_preview = true,
)
