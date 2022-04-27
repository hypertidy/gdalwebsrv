<<<<<<< HEAD
##"https://raw.githubusercontent.com/OSGeo/gdal/master/gdal/frmts/wms/frmt_wms_arcgis_mapserver_tms.xml"

## originally we got them from gdal
if (FALSE) {
  url <- "https://github.com/OSGeo/gdal/tree/master/gdal/frmts/wms"
  library(xml2)
  library(rvest)

  pg <- read_html(url)

  files <- paste0("https://raw.githubusercontent.com",
  gsub("blob/", "", grep("/OSGeo/gdal/blob/master/gdal/frmts/wms/frmt_.*\\.xml$",
       html_attr(html_nodes(pg, "a"), "href"), value = TRUE))
  )

  for (i in seq_along(files)) curl::curl_download(files[i], file.path("data-raw", basename(files[i])))



  file.copy(file.path("data-raw", basename(files)),
            file.path("inst/gdalwmsxml", basename(files)))

}


## added google variants to data-raw 2022-04-27

files <- list.files("data-raw/GDAL_WMS", full.names = TRUE, pattern = "xml$")

## some don't work so

chek <- lapply(files, check_source)
ok <- unlist(lapply(chek, \(x) x$read_ok))
files1 <- files[ok]

library(purrr)
gdalwms_sources <- tibble::tibble(name = gsub("\\.xml$", "", gsub("^frmt_", "", basename(files1))),
                                   source = map_chr(files1, ~ paste0(map_chr(readLines(.x), trimws), collapse = "")))


usethis::use_data(web_sources)
=======
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
gdal_web_sources_internal <- gdal_web_sources
usethis::use_data(gdal_web_sources_internal, internal = TRUE)

>>>>>>> 4815c33444d1cc4f0620fae367dcc243fe28fbee
