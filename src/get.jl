"""
    getLandSea(
        etd  :: ETOPODataset,
        geo  :: GeoRegion = GeoRegion("GLB");
        resolution  :: Int = 60,
        downloadglb :: Bool = false
        FT = Float32
    ) -> LandSea

Retrieve ETOPO 2022 data for a GeoRegion from OPeNDAP servers, or from a previously downloaded Global ETOPO Relief dataset.

Arguments
=========
- `etd` : The ETOPO Dataset containing information on the path to save ETOPO data to
- `geo` : The GeoRegion of interest

Keyword Arguments
=================
- `resolution` : The resolution of the dataset to be downloaded, in units of arc-seconds.  Possible values are 15, 30 and 60, default is 60.
- `downloadglb` : If `true`, download the entire global data first for future extraction in future use. Set automatically to true if more than 10% of points at 60arcsec, or 2.5% of points at 30arcsec is needed to be downloaded.
"""
function getLandSea(
    etd  :: ETOPODataset,
	geo  :: GeoRegion = GeoRegion("GLB");
    resolution  :: Int = 60,
    downloadglb :: Bool = false,
    FT = Float32
)

    # if bedrock
    #     type = "bed"
    # elseif geoid
    #     type = "geoid"
    # else
        type = "surface"
    # end

    if !(resolution==30) && !(resolution==60)
        error("$(modulelog()) - The only possible specifications for the resolution are 30 and 60 arc-seconds, an option for 15 arc-seconds may be added in the future once I figure out how to manage the 288 tiles for 15 arc-second data")
    end

    !isdir(etd.path) ? mkpath(etd.path) : nothing

    fid = "etopo-$(type)-$(geo.ID)_$(resolution)arcsec.nc"
    lsmfnc = joinpath(etd.path,fid)

    if !isfile(lsmfnc)

        @info "$(modulelog()) - The ETOPO $(uppercase(type)) Relief dataset for the \"$(geo.ID)\" GeoRegion is not available, extracting from Global ETOPO $(uppercase(type)) Relief dataset ..."
        flush(stderr)

        area = (geo.E-geo.W)/360 * (geo.N-geo.S)/180
        if area > 0.1 * (resolution/60)^2
            @info "$(modulelog()) - The total specified area covers more than $(10 * (resolution/60)^2)% of global points, set `downloadglb = true` ..."
            flush(stderr)
            downloadglb = true
        end
        glbfnc = joinpath(etd.path,"etopo-$(type)-GLB_$(resolution)arcsec.nc")

        if downloadglb || isfile(glbfnc)

            if isfile(glbfnc)
                @info "$(modulelog()) - The Global ETOPO $(uppercase(type)) Relief dataset has already been downloaded, now using it for extraction ..."
                flush(stderr)
            else
                @info "$(modulelog()) - Downloading the Global ETOPO $(uppercase(type)) Relief dataset ..."
                flush(stderr)
                setup(type,etd.path,resolution)
            end

            gds  = NCDataset(glbfnc)
            glon = gds["longitude"][:]
            glat = gds["latitude"][:]
            goro = gds["z"][:,:]
            close(gds)

            ggrd = RegionGrid(geo,glon,glat)
            nlon = length(ggrd.ilon)
            nlat = length(ggrd.ilat)

            @info "$(modulelog()) - Extracting regional ETOPO $(uppercase(type)) Relief data for the \"$(geo.ID)\" GeoRegion from the Global ETOPO Relief dataset ..."
            flush(stderr)

            roro = extract(goro,ggrd)
            rlsm = deepcopy(roro)
            rlsm[roro .>= 0]   .= 1
            rlsm[roro .<  0]   .= 0
            rlsm[isnan.(roro)] .= NaN

            @info "$(modulelog()) - Saving the regional ETOPO Relief data for \"$(geo.ID)\" GeoRegion ..."
            flush(stderr)

            save(geo,ggrd.lon,ggrd.lat,rlsm,roro,etd.path,type,resolution)

        else

            @info "$(modulelog()) - Opening global ETOPO Relief dataset directly from OPeNDAP servers ..."
            flush(stderr)

            etopods = NCDataset(joinpath(
                "https://www.ngdc.noaa.gov/thredds/dodsC/global/ETOPO2022","$(resolution)s",
                "$(resolution)s_$(etopotype(type))_netcdf",
                "ETOPO_2022_v1_$(resolution)s_N90W180_$(type).nc"
            ))
    
            lon = etopods["lon"].var[:]; nlon = length(lon)
            lat = etopods["lat"].var[:]; nlat = length(lat)
    
            ggrd = RegionGrid(geo,lon,lat)
            ilon = ggrd.ilon; nlon = length(ggrd.ilon)
            ilat = ggrd.ilat; nlat = length(ggrd.ilat)
            rlsm = zeros(Float32,nlon,nlat)
            roro = zeros(Float32,nlon,nlat)
    
            if ilon[1] > ilon[end]
                shift = true
                ilon1 = ilon[1] : nlon; nilon1 = length(ilon1)
                ilon2 = 1 : ilon[end];  nilon2 = length(ilon2)
                tmp1 = @view roro[:,1:nilon1]
                tmp2 = @view roro[:,(nilon1+1):nilon2]
            else
                shift = false
                ilon = ilon[1] : ilon[end]
            end
    
            if ilat[1] > ilat[end]
                ilat = ilat[1] : -1 : ilat[end]
            else
                ilat = ilat[1] : ilat[end]
            end
    
            @info "$(modulelog()) - Extracting regional ETOPO Relief data for the \"$(geo.ID)\" GeoRegion from the Global ETOPO Relief dataset ..."
            flush(stderr)
    
            if !shift
                NCDatasets.load!(etopods["z"].var,roro,ilon,ilat)
            else
                NCDatasets.load!(etopods["z"].var,tmp1,ilon1,ilat)
                NCDatasets.load!(etopods["z"].var,tmp2,ilon2,ilat)
            end
    
            close(etopods)
    
            for ilat = 1 : nlat, ilon = 1 : nlon
                if !isone(ggrd.mask[ilon,ilat])
                    roro[ilon,ilat] = NaN
                end
            end
    
            rlsm[roro .>= 0]   .= 1
            rlsm[roro .<  0]   .= 0
            rlsm[isnan.(roro)] .= NaN
    
            @info "$(modulelog()) - Saving the regional ETOPO Relief data for \"$(geo.ID)\" GeoRegion ..."
            flush(stderr)
    
            save(geo,ggrd.lon,ggrd.lat,rlsm,roro,etd.path,type,resolution)

        end

    end

    lds = NCDataset(lsmfnc)
    lon = lds["longitude"][:]
    lat = lds["latitude"][:]
    lsm = nomissing(lds["lsm"][:,:], NaN)
    oro = nomissing(lds["z"][:,:],   NaN)
    close(lds)

    @info "$(modulelog()) - Retrieving the regional ETOPO $(uppercase(type)) Land-Sea mask for the \"$(geo.ID)\" GeoRegion ..."
    flush(stderr)

    return LandSeaTopo{FT,FT}(lon,lat,lsm,oro)

end

function save(
    geo  :: GeoRegion,
    lon  :: Vector{<:Real},
    lat  :: Vector{<:Real},
    lsm  :: Array{<:Real,2},
    oro  :: Array{<:Real,2},
    path :: AbstractString,
    type :: AbstractString,
    eres :: Int,
)

    fnc = joinpath(etopopath(path),"etopo-$(type)-$(geo.ID)_$(eres)arcsec.nc")
    if isfile(fnc)
        rm(fnc,force=true)
    end

    ds = NCDataset(fnc,"c",attrib = Dict(
        "Conventions" => "CF-1.5",
        "history"     => "Created on $(Dates.now()) by GeoRegions.jl",
        "GDAL_AREA_OR_POINT"     =>"Area",
        "node_offset"            => 1,
        "GDAL_TIFFTAG_COPYRIGHT" => "DOC/NOAA/NESDIS/NCEI > National Centers for Environmental Information, NESDIS, NOAA, U.S. Department of Commerce",
        "GDAL_TIFFTAG_DATETIME"  => 2.0220929123913e13,
        "GDAL_TIFFTAG_IMAGEDESCRIPTION" => "Topography-Bathymetry; EGM2008 height",
        "GDAL"                   => "GDAL 3.3.2, released 2021/09/01",
        "NCO"                    => "netCDF Operators version 4.9.1 (Homepage = http://nco.sf.net, Code = http://github.com/nco/nco)",
        "DODS.strlen"            => 0
    )) 

    ds.dim["longitude"] = length(lon)
    ds.dim["latitude"]  = length(lat)

    nclon = defVar(ds,"longitude",Float32,("longitude",),attrib = Dict(
        "units"     => "degrees_east",
        "long_name" => "longitude",
    ))

    nclat = defVar(ds,"latitude",Float32,("latitude",),attrib = Dict(
        "units"     => "degrees_north",
        "long_name" => "latitude",
    ))

    nclsm = defVar(ds,"lsm",Float32,("longitude","latitude",),attrib = Dict(
        "long_name" => "land_sea_mask",
        "full_name" => "Land-Sea Mask",
        "units"     => "0-1",
    ))

    ncoro = defVar(ds,"z",Float32,("longitude","latitude",),attrib = Dict(
        "long_name" => "height",
        "full_name" => "$(etoponamestring(type)) Height",
        "units"     => "m",
    ))

    nclon[:] = lon
    nclat[:] = lat
    nclsm[:,:] = lsm
    ncoro[:,:] = oro

    close(ds)

end

function setup(
    type :: AbstractString,
    path :: AbstractString,
    resolution :: Int,
)

    @info "$(modulelog()) - The Global ETOPO $(uppercase(type)) Land-Sea mask dataset is not available, downloading from ETOPO OPeNDAP servers ..."
    flush(stderr)
    
    download(joinpath(
        "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022","$(resolution)s",
        "$(resolution)s_$(etopotype(type))_netcdf",
        "ETOPO_2022_v1_$(resolution)s_N90W180_$(type).nc"
    ),"tmp.nc")

    eds = NCDataset("tmp.nc")

    lon = nomissing(eds["lon"][:]); nlon = length(lon)
    lat = nomissing(eds["lat"][:]); nlat = length(lat)
    oro = nomissing(eds["z"][:,:])
    lsm = zeros(Float32,nlon,nlat)

    for ilat = 1 : nlat, ilon = 1 : nlon
        if oro[ilon,ilat] >= 0
            lsm[ilon,ilat] = 1
        end
    end

    close(eds)

	save(GeoRegion("GLB"),lon,lat,lsm,oro,etopopath(path),type,resolution)

    rm("tmp.nc",force=true)

    gds  = NCDataset(joinpath(etopopath(path),"etopo-$(type)-GLB_$(resolution)arcsec.nc"))
    glon = gds["longitude"][:]
    glat = gds["latitude"][:]
    goro = gds["z"][:,:]
    close(gds)

    ggrd = RegionGrid(GeoRegion("GLB"),glon,glat)

    @info "$(modulelog()) - Extracting regional ETOPO $(uppercase(type)) Land-Sea mask for the \"GLB\" GeoRegion from the Global ETOPO Land-Sea mask dataset ..."
    flush(stderr)
    
    roro = extract(goro,ggrd)
    rlsm = deepcopy(roro)
    rlsm[roro .>= 0] .= 1
    rlsm[roro .<  0] .= 0

    save(GeoRegion("GLB"),ggrd.lon,ggrd.lat,rlsm,roro,etopopath(path),type,resolution)

end