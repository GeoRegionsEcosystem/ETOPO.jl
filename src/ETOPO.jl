module ETOPO

using Dates
using GeoRegions
using LandSea
using Logging
using Printf
using RegionGrids

import LandSea: getLandSea

using Reexport
@reexport using GeoRegions
@reexport using NCDatasets

export
        getLandSea, ETOPODataset

struct ETOPODataset{ST<:AbstractString}
    path :: ST
end

modulelog() = "$(now()) - ETOPO.jl"
ETOPODataset(ST = String; path :: AbstractString = homedir()) = ETOPODataset{ST}(path)

include("get.jl")
include("backend.jl")

end
