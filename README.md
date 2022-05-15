
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gdalwebsrv

<!-- badges: start -->
<!-- badges: end -->

The goal of gdalwebsrv is to provide access to some online image servers
using standard tools.

This project contains no code for *reading rasters*, it’s simply for
creating a [list of GDAL-readable imagery
sources](https://github.com/hypertidy/gdalwebsrv/blob/master/inst/bundle/gdalwebsrv.csv).

This was a package, but it’s not anymore.

## List of GDAL raster sources

The list is not organized or comprehensive, it just collects what I’ve
learnt in this project, in
[gdalio](https://github.com/hypertidy/gdalio), in
[wmts](https://github.com/hypertidy/wmts), and in
[tasmapr](https://github.com/mdsumner/tasmapr).

All the imagery sources of those other projects are in the [the list
here](https://github.com/hypertidy/gdalwebsrv/blob/master/inst/bundle/gdalwebsrv.csv)

Get the list with

``` r
read.csv(url("https://raw.githubusercontent.com/hypertidy/gdalwebsrv/master/inst/bundle/gdalwebsrv.csv"),
           colClasses = c("character", "character"), check.names = FALSE)
```

or just download it for your own exploration.

You can hit the `$source` column with GDAL command line, R packages,
python packages, or your GIS.

## Code of Conduct

Please note that the gdalwebsrv project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
