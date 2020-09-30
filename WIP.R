## see some notes here
##https://gist.github.com/mdsumner/91b2dfe5c7acba9b3aa8fb30d01b8bad

## see extra sources for the arcgis one here
## https://github.com/mdsumner/dirigible/issues/4#issuecomment-698869899


srv <- function(ex, server) {
  library(lazyraster)
  if (missing(ex)) {
    ex <- c(-20037508, 20037508, -20037508, 20037508) - c(-1, 1, -1, 1) * 1e6
  }
  if (missing(server)) {
    server <- sample(available_sources(), 1L)
  }

  #cr <- crop(lazyraster(server_file(server)), ex)
  cr <- lazyraster(server_file(server))
  raster::brick(as_raster(cr, band = 1),
                as_raster(cr, band = 2),
                as_raster(cr, band = 3))

}
library(raster)
ags <- function(ex) {
  srv(ex, "wms_arcgis_mapserver_tms")
}
bm <- function(ex) {
  srv(ex, "wms_bluemarble_s3_tms")
}
gmap <- function(ex) {
  srv(ex, "wms_googlemaps_tms")
}
osm <- function(ex) {
  srv(ex, "wms_openstreetmap_tms")
}
ve <- function(ex) {
  srv(ex, "wms_virtualearth")
}

par(mfrow = c(3, 2))
plotRGB(ags())
plotRGB(bm())
plotRGB(gmap())
plotRGB(osm())
plotRGB(ve())


warp_to_yrdata <- function(x, yrdata = NULL, dim = NULL, src_wkt =  "") {
  if (is.null(yrdata)) {
    ex <- spex::spex()
  } else {
    ex <- raster::extent(yrdata)
  }
  ## maybe use crs_any (or control it here)
  wkt <- crsmeta::crs_wkt(yrdata)
  if (is.na(wkt)) {
    wkt <- dirigible:::proj_to_wkt_gdal_cpp(crsmeta::crs_proj(yrdata))
  }
 if (names(dev.cur()) == "null device" && is.null(dim)) {
    dim <- c(1024, 1024)
  } else {
    if (is.null(dim)) dim <- dev.size("px")
  }
  target <- raster::raster(ex, nrows = dim[1L], ncols = dim[2L])
  gt <- affinity:::raster_to_gt(target)  # remotes::install_github("hypertidy/affinity")
  info <- dirigible:::raster_info_gdal_cpp(x, min_max = FALSE)
  ## warp the source grid to the target grid
  vals <- lapply(seq_len(info$bands), function(.x) dirigible:::warp_in_memory_gdal_cpp(x, source_WKT = src_wkt,
                                              target_geotransform = gt,
                                              target_dim = dim[2:1],
                                              target_WKT = wkt,
                                              band = .x))

  structure(list(values = vals, dim = dim, crs = wkt, ex = c(xmin = raster::xmin(ex), xmax = raster::xmax(ex),
                                                             ymin = raster::ymin(ex), ymax = raster::ymax(ex))),
            class = c("raw_raster_data", "list"))
}

warp_to_yrdata_raster <- function(x, yrdata = NULL, dim = NULL, src_wkt = "") {
  d <- warp_to_yrdata(x, yrdata = yrdata, dim = dim, src_wkt = src_wkt)

  raster::setValues(raster::brick(replicate(length(d$values),
                                            raster::raster(raster::extent(d$ex), nrows = d$dim[1L], ncols = d$dim[2L]), simplify = FALSE)),
                    matrix(unlist(d$values), ncol = length(d$values)))
}






























mydata <- sf::st_transform(ozmaps::abs_ced, "+proj=laea +lon_0=80 +lat_0=-30")
(srv <- server_file("wms_bluemarble_s3_tms"))
## "./gdalwebsrv/gdalwmsxml/frmt_wms_bluemarble_s3_tms.xml"
##  <ServerUrl>http://s3.amazonaws.com/com.modestmaps.bluemarble/${z}-r${y}-c${x}.jpg</ServerUrl>

img <- warp_to_yrdata_raster(srv, mydata)

library(anglr)
(mesh <- as.mesh3d(DEL0(mydata, max_area = 1e8), image_texture = img))
## mesh3d object with 163916 vertices, 249085 triangles and 0 quads.
mesh_plot(mesh)
plot(mydata, add = TRUE, border = sample(viridis::viridis(nrow(mydata))), lwd = 2)













mesh0 <- as.mesh3d(silicate::TRI0(mydata), image_texture = img)
plot3d(mesh0)
plot(silicate::SC(silicate::TRI0(mydata)))















