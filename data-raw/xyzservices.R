u <- "https://raw.githubusercontent.com/geopandas/xyzservices/main/xyzservices/data/providers.json"

j <- jsonlite::fromJSON(u)
library(tidyverse)
x <- unlist(j)

has_matrix <- function(x) any(purrr::map_lgl(x, is.matrix))
as_tibble_with_matrix <- function(x) {
  if (has_matrix(x)) {
    x$bounds <- list(tibble::as_tibble(setNames(as.list(c(x$bounds)), c("xmin", "ymin", "xmax", "ymax"))))
    out <- tibble::as_tibble(x) %>% tidyr::unnest(bounds)
  } else {
    out <- tibble::as_tibble(x)
  }
  ## flesh out the keys now
  #scan("", 1)

  ## these are exceptions to make, we don't have a data token for subdomain so just use "a" (but see below!)
  ## server, some have abcd in $subdomains
  out$s <- ""
  if ("subdomains" %in% names(out)) {
    out$s <- substr(out$subdomains, 1, 1)
    browser()
  }

  out$x <- "{x}"
  out$y <- "{y}"
  out$z <- "{z}"
  out$r <- ""  ## r is "@2x" for doubling the dimension of an image
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

# there are 8 ways of specifying an API key
#which(map_lgl(xyzservices, ~any(grepl("insert", .x))))
#apikey     accessToken             key          apiKey          app_id        app_code subscriptionKey
#17              20              25              28              30              31              42

