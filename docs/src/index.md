```@raw html
---
layout: home

hero:
  name: "ETOPO.jl"
  text: "Extraction of Gridded Geospatial Data"
  tagline: Subsetting and Extracting Gridded Geospatial Data for Geographic Regions of Interest.
  image:
    src: /logo.png
    alt: ETOPO
  actions:
    - theme: brand
      text: Getting Started
      link: /etopo
    - theme: alt
      text: API
      link: /api
    - theme: alt
      text: View on Github
      link: https://github.com/GeoRegionsEcosystem/ETOPO.jl

features:
  - title: 🌍 Define Grids of Interest
    details: You have a (Geo)Region of interest and some gridded data? Let's define a Grid for it.
  - title: ⚙️ Flexible Grid Types
    details: Maybe your data isn't rectilinear on the Lon/Lat Grid? Don't worry, we've got you covered.
  - title: 🔍 Extraction made Easy
    details: Already defined a Grid for your (Geo)Region of interest? Now let's Extract Some Data!
---
```

## Introduction

ETOPO.jl is a lightweight Julia package that builds upon the [GeoRegions Ecosystem](https://github.com/GeoRegionsEcosystem), and in particular [LandSea.jl](https://github.com/GeoRegionsEcosystem/LandSea.jl) to download the ETOPO topographical datasets.

## Installation Instructions

The latest version of ETOPO can be installed using the Julia package manager (accessed by pressing `]` in the Julia command prompt)
```julia-repl
julia> ]
(@v1.10) pkg> add ETOPO
```

You can update `ETOPO.jl` to the latest version using
```julia-repl
(@v1.10) pkg> update ETOPO
```

And if you want to get the latest release without waiting for me to update the Julia Registry (although this generally isn't necessary since I make a point to release patch versions as soon as I find bugs or add new working features), you may fix the version to the `main` branch of the GitHub repository:
```julia-repl
(@v1.10) pkg> add ETOPO#main
```

## Getting help
If you are interested in using `ETOPO.jl` or are trying to figure out how to use it, please feel free to ask me questions and get in touch!  Please feel free to [open an issue](https://github.com/GeoRegionsEcosystem/ETOPO.jl/issues/new) if you have any questions, comments, suggestions, etc!
