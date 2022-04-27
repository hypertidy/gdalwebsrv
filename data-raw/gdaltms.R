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
