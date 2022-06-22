## bundle up raadtools sources
library(raadtools)

get_both_hemisphere_files_wide <- function() {
  north = icefiles(hemisphere = "north")
  south = icefiles(hemisphere = "south")

  north$vrt_dsn <-  sprintf(raadtools:::.north_nsidc_vrt, unlist(lapply(split(north, 1:nrow(north)), function(.x)
    gsub(.x$root, "/vsicurl/ftp:/", .x$fullname))))
  south$vrt_dsn <-  sprintf( raadtools:::.south_ndsic_vrt, unlist(lapply(split(south, 1:nrow(south)), function(.x)
    gsub(.x$root, "/vsicurl/ftp:/", .x$fullname))))


  dplyr::inner_join(north |> dplyr::transmute(date, north_vrt_dsn = vrt_dsn),
                    south |> dplyr::transmute(date, south_vrt_dsn = vrt_dsn), "date")
}
files <- get_both_hemisphere_files_wide()

readr::write_csv(files, "inst/bundle/raad_nsidc_25km_seaice.csv.gz")
