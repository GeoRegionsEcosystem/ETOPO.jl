<p align="center">
<img alt="ETOPO.jl Logo" src=https://raw.githubusercontent.com/GeoRegionsEcosystem/ETOPO.jl/main/src/logosmall.png />
</p>

# **<div align="center">ETOPO.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://github.com/GeoRegionsEcosystem/ETOPO.jl/actions/workflows/ci.yml">
    <img alt="GitHub Actions" src="https://github.com/GeoRegionsEcosystem/ETOPO.jl/actions/workflows/ci.yml/badge.svg?branch=main&style=flat-square">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
	<img alt="MIT License" src="https://img.shields.io/github/v/release/GeoRegionsEcosystem/ETOPO.jl.svg?style=flat-square">
  <a href="https://GeoRegionsEcosystem.github.io/ETOPO.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://GeoRegionsEcosystem.github.io/ETOPO.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

## **Introduction**

ETOPO.jl is a Julia package that aims to streamline the following process(es):
* Downloading of the ETOPO dataset for topography
* Matching the ETOPO topographic data to the corresponding Land-Sea derived from the [Global 1-km Consensus Land-Cover dataset](https://www.earthenv.org/landcover)

Currently supported ETOPO datasets:
* Resolution: 30 arcsec, 60 arcsec
* Type: Bedrock, Ice-Surface

There are plans in the future to support the 15 arcsec dataset, but because there is no corresponding Land-Sea mask, and because 15 arcsec data is harder to handle than the 30 arcsec data, adding this feature has been put on hold.

ETOPO.jl can be installed via
```
] add ETOPO
```

## **Usage**

Please refer to the [documentation](https://georegionsecosystem.github.io/ETOPO.jl/dev/) for instructions and examples.