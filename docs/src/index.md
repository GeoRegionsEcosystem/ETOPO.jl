```@raw html
---
layout: home

hero:
  name: "ETOPO.jl"
  text: "Downloading ETOPO Relief Datasets"
  tagline: Download, extract and manipulate the ETOPO Global Relief Model using this lightweight Julia package.
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
  - title: 🔍 Comprehensive
    details: There are several different options of choice for you, be it resolution, or surface-type from which the topography is measured.
  - title: 🌍 Topography of Interest
    details: You don't have to download the global topography, only for your (Geo)Region of interest, saving you time and disk space for small domains.
  - title: 🏔️ LandSea Mask
    details: Is it Land or is it Ocean? Currently we use the topographic height to determine this feature, but more updates are on the way!
---
```

## Introduction

ETOPO.jl is a lightweight Julia package that builds upon the [GeoRegions Ecosystem](https://github.com/GeoRegionsEcosystem), and in particular [LandSea.jl](https://github.com/GeoRegionsEcosystem/LandSea.jl), to download the ETOPO topographical datasets.

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
