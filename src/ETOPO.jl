module ETOPO

using Dates
using LandSea
using Logging
using Printf

import LandSea: getLandSea

using Reexport
@reexport using RegionGrids
@reexport using NCDatasets

export
        getLandSea

struct ETOPODataset{ST<:AbstractString}
    path :: ST
end

modulelog() = "$(now()) - ETOPO.jl"
ETOPODataset(ST = String; path :: AbstractString = homedir()) = ETOPODataset{ST}(path)

include("get.jl")
include("backend.jl")

end
