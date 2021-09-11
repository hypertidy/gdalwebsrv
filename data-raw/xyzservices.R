u <- "https://raw.githubusercontent.com/geopandas/xyzservices/main/xyzservices/data/providers.json"

j <- jsonlite::fromJSON(u)
library(tidyverse)
x <- unlist(j)

has_matrix <- function(x) any(purrr::map_lgl(x, is.matrix))
as_tibble_with_matrix <- function(x) {
  if (has_matrix(x)) {
    x$bounds <- list(tibble::as_tibble(setNames(as.list(c(x$bounds)), c("xmin", "ymin", "xmax", "ymax"))))
    tibble::as_tibble(x) %>% tidyr::unnest(bounds)
  } else {
    tibble::as_tibble(x)
  }
}


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
