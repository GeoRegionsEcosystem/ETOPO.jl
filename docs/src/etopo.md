# The Basics of ETOPO.jl

ETOPO.jl builds upon the functionality of [LandSea.jl](https://github.com/GeoRegionsEcosystem/LandSea.jl) to:

* Download, extract and analyze the ETOPO Global Relief Model
* Match it with a corresponding Land-Sea Mask

One benefit of using this package is that it pairs with [GeoRegions.jl](https://github.com/GeoRegionsEcosystem/GeoRegions.jl) such that for small regions only the relevant region of your choosing is extracted. This saves lot of time for geographic regions of interest that are **small in area relative to the globe**.

!!! tip "Downloading automatically triggers for larger regions"
    For larger regions, it is often faster to download the relevant ETOPO dataset directly, rather than perform the extraction online using NCDatasets.jl (which extracts from the OPeNDAP servers). Therefore, beyond a certain threshold (currently at >10% of global area) ETOPO.jl will automatically trigger a download of the full dataset.