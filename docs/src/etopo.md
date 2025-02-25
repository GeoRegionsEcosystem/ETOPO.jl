# The Basics of ETOPO.jl

ETOPO.jl builds upon the functionality of [LandSea.jl](https://github.com/GeoRegionsEcosystem/LandSea.jl) to:

* Download, extract and analyze the ETOPO Global Relief Model
* Match it with a corresponding Land-Sea Mask

One benefit of using this package is that it pairs with [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl) such that for small regions only the relevant region of your choosing is extracted. This saves lot of time for geographic regions of interest that are **small in area relative to the globe**.

!!! tip "Downloading automatically triggers for larger regions"
    For larger regions, it is often faster to download the relevant ETOPO dataset directly, rather than perform the extraction online using NCDatasets.jl (which extracts from the OPeNDAP servers). Therefore, beyond a certain threshold (currently at >10% of global area) ETOPO.jl will automatically trigger a download of the full dataset.

## An Example of using ETOPO.jl

```@example example
using ETOPO
using DelimitedFiles
using CairoMakie

download("https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt","coast.cst")
coast = readdlm("coast.cst",comments=true)
clon  = coast[:,1]
clat  = coast[:,2]
nothing
```

Let us define a small GeoRegion of interest

```@example example
geo = GeoRegion("AR6_SAS")
```

And let us define where the ETOPO Dataset is being held

```@example example
etd = ETOPODataset(path=pwd())
```

Now, let us retrieve the ETOPO Relief data without needing to download anything

```@example example
lsd = getLandSea(etd,geo)
```

And then now we plot both the land-sea mask (top), and the topographic height (bottom).

```@example example
fig = Figure()

ax1 = Axis(
    fig[1,1],width=400,height=400*(geo.N-geo.S+2)/(geo.E-geo.W+4),
    limits=(geo.W-2,geo.E+2,geo.S-1,geo.N+1)
)
heatmap!(ax1,lsd.lon,lsd.lat,lsd.lsm,colorrange=(-0.5,1.5),colormap=:delta)
lines!(ax1,clon,clat,color=:black,linewidth=1
)

ax2 = Axis(
    fig[2,1],width=400,height=400*(geo.N-geo.S+2)/(geo.E-geo.W+4),
    limits=(geo.W-2,geo.E+2,geo.S-1,geo.N+1)
)
heatmap!(ax2,lsd.lon,lsd.lat,lsd.z ./1e3,colorrange=(-10,10),colormap=:topo)
lines!(ax2,clon,clat,color=:black,linewidth=1)

resize_to_layout!(fig)
fig
```