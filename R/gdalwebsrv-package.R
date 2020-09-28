#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL


#' gdalwebsrv
#'
#' Provides files from the GDAL project to access online imagery servers.
#' @docType package
NULL

#' GDAL web servers
#'
#' Source files for various image servers available via GDAL.
#'
#' `gdal_web_sources` is a data frame of `name`, and `file` which is relative to the installed
#' package (see Examples).
#' @docType data
#' @examples
#' system.file(gdal_web_sources$file[1L], package = "gdalwebsrv", mustWork = TRUE)
'gdal_web_sources'

#' GDAL web source names
#'
#' Names of available image servers
#'
#' @return character vector
#' @export
#' @examples
#' available_sources()
available_sources <- function() {
  gdal_web_sources[["name"]]
}

#' GDAL web sources files
#'
#' Find files providinging image server by name. These files may be used to access
#' raster data using functions from packages raster, stars, vapour, terra, sf (and others) or
#' from other tools that are GDAL enabled.
#'
#' See [available_sources()] for available server names.
#'
#' @param name name of source
#' @return character vector
#' @export
#' @examples
#' server_file(gdal_web_sources$name[1L])
server_file <- function(name) {
  name <- name[1L]
  ## note kludgy reconstruction of actual file
  pos <- match(sprintf("frmt_%s.xml", name), basename(gdal_web_sources[["file"]]))
  if (is.na(pos)) stop(sprintf("cannot find server %s", name))
  system.file(gdal_web_sources[["file"]][pos], package = "gdalwebsrv", mustWork = TRUE)
}
