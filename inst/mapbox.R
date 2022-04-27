
##https://github.com/mdsumner/mapbox.stuff

reprex::reprex({
## install.packages("vapour")
## remotes::install_github("hypertidy/gdalio)
library(gdalio)
## load format-specific functions like gdalio_raster()
source(system.file("raster_format/raster_format.codeR", package = "gdalio", mustWork = TRUE))

.handle_key <- function(key) {
  if (is.null(key)) {
    key <- Sys.getenv("MAPBOX_API_KEY")
    if (is.null(key)) stop("provide mapbox 'key' or via MAPBOX_API_KEY env var")
  }
  key
}

# wrapped template for mapbox tiles in gdal TMS syntax
mapbox_tilexyz_gdal <- function(type = "v4/mapbox.satellite", key = NULL) {
  key <- .handle_key(key)
  if (nchar(type) < 1) stop("type must be a useable mapbox tile id name e.g. 'v4/mapbox.satellite'")
  base <- "https://api.mapbox.com/%s/${z}/${x}/${y}?access_token=%s"
 sprintf('<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>%s</ServerUrl>
  </Service>
  <DataWindow>
    <UpperLeftX>-20037508.34</UpperLeftX>
    <UpperLeftY>20037508.34</UpperLeftY>
    <LowerRightX>20037508.34</LowerRightX>
    <LowerRightY>-20037508.34</LowerRightY>
    <TileLevel>22</TileLevel>
    <YOrigin>top</YOrigin>
  </DataWindow>
  <Projection>EPSG:900913</Projection>
  <BlockSizeX>256</BlockSizeX>
  <BlockSizeY>256</BlockSizeY>
  <BandsCount>3</BandsCount>
  <Cache/>
</GDAL_WMS>', base)
}

# template for mapbox tiles in "read image tile" syntax (no extent, projection metadata)
## this is good for testing source types etc. because if a generic image reader can't read a file
## from this then higher tools (gdal etc) won't either
mapbox_tilexyz <- function(type = "v4/mapbox.satellite", key = NULL) {
  key <- .handle_key(key)
  if (nchar(type) < 1) stop("type must be a useable mapbox tile id name e.g. 'v4/mapbox.satellite'")
  base <- "https://api.mapbox.com/%s/${z}/${x}/${y}.jpg?access_token=%s"
  sprintf(base, type, key)
}
mapbox_tilexyz_terrain <- function(type = "v4/mapbox.terrain-rgb", key = NULL) {
  key <- .handle_key(key)
  if (nchar(type) < 1) stop("type must be a useable mapbox tile id name e.g. 'v4/mapbox.satellite'")
  base <- "https://api.mapbox.com/%s/${z}/${x}/${y}.pngraw?access_token=%s"
  #print(type)
  sprintf(base, type, key)
}
xyz <- function(u, x, y = NULL, z = NULL, tile2x = FALSE) {
  if (missing(x)) {
    x <- 0
    if (is.null(y)) y <- 0
    if (is.null(z)) z <- 0
  }
  xyz0 <- xyz.coords(x, y, z)
  zero_integer <- function(x) {
    pmax(0, as.integer(x))
  }
  ## we don't want any negative or floating point values as tile index
  xyz0[c("x", "y", "z")] <- lapply(xyz0[c("x", "y", "z")], zero_integer)
  u <- gsub("\\$\\{x}", xyz0$x, u)
  if (tile2x) u <- gsub("\\$\\{y}", "\\$\\{y}@2x", u)
  u <- gsub("\\$\\{y}", xyz0$y, u)
  u <- gsub("\\$\\{z}", xyz0$z, u)
  u
}

## we need vsicurl for gdal tools, but not for generic url/file readers
vsicurl <- function(x) {
  file.path("/vsicurl", x)
}


## build mapbox WMTS data source name from a custom style
mapbox_wmts <- function(type = "", key = NULL) {
  key <- .handle_key(key)
  if (nchar(type) < 1) stop("type must be a useable mapbox style name e.g. 'styles/v1/<username>/<style_id>'")
  base <- "WMTS:https://api.mapbox.com/%s/wmts?access_token=%s"
  sprintf(base,
          type, key)
}







## e.g.
jpegurl <- xyz(mapbox_tilexyz(),  14, 14, 6, tile2x = TRUE)
vapour::vapour_driver(vsicurl(jpegurl))
try(vapour::vapour_driver(jpegurl))  ## fail
magick::image_read(jpegurl)  ## succeed

## xyz is X-tile, Y-tile, Z-oom level  (though in the URL it's Z/X/Y ;)
raster::plotRGB(raster::brick(vsicurl(jpegurl)))

## terrain
unpack_rgb <- function(x) {
  -10000 + ((x[[1]] * 256 * 256 + x[[2]] * 256 + x[[3]]) * 0.1)
}

library(gdalio)

op <- par(mfrow = c(2, 2), mar = rep(0, 4))
raster::image(unpack_rgb(raster::brick(vsicurl(xyz(mapbox_tilexyz_terrain(),  14, 14, 6, tile2x = TRUE)))), col = grey.colors(256), asp = 1, axes = F)
raster::plotRGB(raster::brick(vsicurl(xyz(mapbox_tilexyz(),  14, 14, 6, tile2x = TRUE))))
bb_from_tile <- slippymath::tile_bbox(14, 14, 6)
gdalio_set_default_grid(list(extent = bb_from_tile[c(1, 3, 2, 4)], dimension = c(256, 256), projection = "EPSG:900913"))
raster::plotRGB(gdalio_raster(mapbox_wmts("styles/v1/mdsumner/ckb4o07v00s5i1irmzw7obvbr"), bands = 1:3))
raster::plotRGB(gdalio_raster(mapbox_wmts("v4/mapbox.satellite"), bands = 1:3))






## styles I have in my account, published publically
## Satellite
sat <- mapbox_wmts("styles/v1/mdsumner/cjy6m24oh1amo1cmy74uk23n6")
## Basic
bas <- mapbox_wmts("styles/v1/mdsumner/ckb4o07v00s5i1irmzw7obvbr")
## Terrain
ter <- mapbox_wmts("styles/v1/mdsumner/")
## set desired grid: extent, dimension, projection
g <- list(extent = c(-1, 1, -.5, .5) * 3e5, dimension = 768 * c(1, 0.5),
           projection = "+proj=laea +lon_0=138 +lat_0=-35")
gdalio_set_default_grid(g)
sat_im <- gdalio_terra(sat, bands = 1:3, resample = "cubic", band_output_type = "Int32")
bas_im <- gdalio_terra(bas, bands = 1:3, resample = "cubic", band_output_type = "Int32")
op <- par(mfrow = c(2, 1))
terra::plotRGB(sat_im)
terra::plotRGB(bas_im)
par(op)

})
