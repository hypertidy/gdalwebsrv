#' Check GDAL source
#'
#' Attempt to get (1) info and (2) read from an online raster source.
#'
#' Used in creating source sets.
#' @param x GDAL readable DSN (Data Source Name)
#'
#' @return list of 'info_ok', 'read_ok', 'info', and 'read'
#' @export
#'
#' @examples
#'
check_source <- function(x) {
  info_check <- try(vapour::vapour_raster_info(x), silent = TRUE)
  result <- NULL
  ok <- !inherits(info_check, "try-error")
  read_ok <- FALSE
  if (ok) {
    result <- try(vapour::vapour_read_raster(x, window = c(0, 0, 1, 1), band = seq_len(info_check$bands)))
    read_ok <- if (inherits(result, "try-error")) FALSE else TRUE

  }
  list(info_ok = ok, read_ok = read_ok, info = info_check, read = result)

}
