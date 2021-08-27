# "https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/frmts/wms/frmt_wms_arcgis_mapserver_tms.xml"
#
#
# url <- "https://github.com/OSGeo/gdal/tree/master/gdal/frmts/wms"
# library(xml2)
# library(rvest)
#
# pg <- read_html(url)
#
# files <- paste0("https://raw.githubusercontent.com",
# gsub("blob/", "", grep("/OSGeo/gdal/blob/master/gdal/frmts/wms/frmt_.*\\.xml$",
#      html_attr(html_nodes(pg, "a"), "href"), value = TRUE))
# )
#
# for (i in seq_along(files)) curl::curl_download(files[i], file.path("data-raw", basename(files[i])))
#
#
# file.copy(file.path("data-raw", basename(files)),
#           file.path("inst/gdalwmsxml", basename(files)))

files <- list.files("inst/gdalwmsxml", full.name = TRUE)
gdal_web_sources <- tibble::tibble(name = gsub("\\.xml$", "", gsub("^frmt_", "", basename(files))),
                                   file  =file.path( "gdalwmsxml", basename(files)))

## limited (US only, small)
limit <- 1
## don't work
bad <- 2:5
## only one bandf
band1 <- c(7)
## projection not known or longlat
proj0 <- c(10, 11, 12, 13, 15, 16) + 5 ## plus 5 since added new google ones

gdal_web_sources <- gdal_web_sources[-c(limit, bad, band1, proj0), ]
usethis::use_data(gdal_web_sources)
#usethis::use_data(gdal_web_sources, internal = TRUE)

