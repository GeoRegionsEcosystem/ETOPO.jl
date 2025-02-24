using Documenter
using DocumenterVitepress
using ETOPO

using ColorSchemes
import CairoMakie

CairoMakie.activate!(type = "svg")

DocMeta.setdocmeta!(ETOPO, :DocTestSetup, :(using ETOPO); recursive=true)

makedocs(;
    modules  = [ETOPO],
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "ETOPO.jl",
    doctest  = false,
    warnonly = true,
    format   = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/GeoRegionsEcosystem/ETOPO.jl",
    ),
    pages=[
        "Home"            => "index.md",
        "Getting Started" => "etopo.md",
        "API List"        => "api.md",
    ],
)

recursive_find(directory, pattern) =
    mapreduce(vcat, walkdir(directory)) do (root, dirs, files)
        joinpath.(root, filter(contains(pattern), files))
    end

files = []
for pattern in [r"\.cst", r"\.nc"]
    global files = vcat(files, recursive_find(@__DIR__, pattern))
end

for file in files
    rm(file)
end

deploydocs(;
    repo      = "github.com/GeoRegionsEcosystem/ETOPO.jl.git",
    target    = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch    = "gh-pages",
)
