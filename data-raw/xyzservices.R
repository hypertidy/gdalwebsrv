u <- "https://raw.githubusercontent.com/geopandas/xyzservices/main/xyzservices/data/providers.json"

j <- jsonlite::fromJSON(u)
library(tidyverse)
x <- unlist(j)

has_matrix <- function(x) any(purrr::map_lgl(x, is.matrix))
as_tibble_with_matrix <- function(x) {
  ## some subdomains are arrays, but still the same set of abcd or 01234
  # unique(xyzservices$subdomains)
  # [1] ""     "abcd" "1234" "0123" "12"

  x$subdomains <- paste0(unlist(x$subdomains), collapse = "") ## technically we are missing ""
  if (has_matrix(x)) {
    ## some of these are in the wrong order
    BOUNDS <- c(x$bounds)
    BOUNDS[1:2] <- sort(BOUNDS[1:2]) ## lat
    BOUNDS[3:4] <- sort(BOUNDS[3:4]) ## lon

    x$bounds <- list(tibble::as_tibble(setNames(as.list(BOUNDS), c("ymin", "ymax", "xmin", "xmax"))))

    out <- tibble::as_tibble(x) %>% tidyr::unnest(bounds)
  } else {
    out <- tibble::as_tibble(x)
  }
  if (any(lengths(x) > 1)) stop("still some arrays to unpack")
  ## flesh out the keys now
  #scan("", 1)

  ## these are exceptions to make, we don't have a data token for subdomain so just use "a" (but see below!)
  ## server, some have abcd in $subdomains
  out$s <- "a"  ## some don't have the subdomains field i.e.  "url": "https://maps-{s}.onemap.sg/v3/{variant}/{z}/{x}/{y}.png",
  if ("subdomains" %in% names(out) && nchar(out$subdomains) > 0) {
    out$s <- substr(out$subdomains, 1, 1)

  }

  out$x <- "{x}"
  out$y <- "{y}"
  out$z <- "{z}"
  out$r <- ""  ## r is "@2x" for doubling the dimension of an image
  out$time <- "2020-01-01"
  ## $time is getting smashed as in
  # https://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_Land_Surface_Temp_Day/default/ <here> {time} /GoogleMapsCompatible_Level7/${z}/${y}/${x}.png<
#  if (grepl("https://maps-\\{s}.onemap.sg", out$url)) browser()
  out$url <- with(out, glue::glue(url))
  out
}

#for ${s} subdomains we have to unpack these, I assume each is just one token not literally abcd or 1234
# unique(xyzservices$subdomains)
# [1] NA     "abcd" "1234" ""     "1"    "2"    "3"    "4"    "0123" "12"

l <- list()
for (i in seq_along(j)) {
  if ("url" %in% names(j[[i]])) {

    l <-  c(l, list(as_tibble_with_matrix(j[[i]])))
  } else {
    for (ii in seq_along(j[[i]])) {
      l <-  c(l, list(as_tibble_with_matrix(j[[i]][[ii]])))
    }
  }
}

xyzservices <- bind_rows(l)

A <- 6378137
radians <- function(x) x * pi/180
merckx <- function(lon) A * radians(lon)
mercky <- function(lat) A * log(tan((pi * 0.25) + (0.5 * radians(lat))))

xyzservices <- xyzservices %>%
                  mutate(xmin = merckx(xmin), xmax = merckx(xmax),
                         ymin = mercky(ymin), ymax = mercky(ymax))


# there are 8 ways of specifying an API key
#which(map_lgl(xyzservices, ~any(grepl("insert", .x))))
#apikey     accessToken             key          apiKey          app_id        app_code subscriptionKey
#17              20              25              28              30              31              42

