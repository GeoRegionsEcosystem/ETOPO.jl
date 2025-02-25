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

"""
    ETOPODataset

An abstract type for the ETOPO dataset, containing information on the following fields:
- `path` : The directory in which the ETOPO data downloads, storage and analysis are conducted, default is the home directory called by `homedir()`
"""
struct ETOPODataset{ST<:AbstractString}
    path :: ST
end

modulelog() = "$(now()) - ETOPO.jl"
etopopath(path) = splitpath(path)[end] !== "ETOPO" ? joinpath(path,"ETOPO") : path

"""
    ETOPODataset(
        ST = String;
        path :: AbstractString = homedir(),
    ) -> etd :: ETOPODataset{ST}

Creates an `ETOPODataset` dataset `etd` to define where to save `ETOPO` datasets.

Keyword Arguments
=================
- `path` : The directory in which the folder `ETOPO` will be created for data downloads, storage and analysis, default is the home directoy called by `homedir()`
"""
ETOPODataset(ST = String; path :: AbstractString = homedir()) = ETOPODataset{ST}(etopopath(path))

function show(io::IO, etd::ETOPODataset{ST}) where {ST<:AbstractString}
    print(
		io,
		"The ETOPO Dataset {$ST} has the following properties:\n",
		"    Data Directory (path) : ", etd.path, '\n',
	)
end

include("get.jl")
include("backend.jl")

end
