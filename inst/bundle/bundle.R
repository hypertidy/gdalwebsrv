## bundle all up
env <- environment()
library(tibble)
ss <- lapply(list.files("data-raw", pattern = "\\.R$", full.names = TRUE), source, local = env)

src <- do.call(rbind, lapply(grep("_sources", ls(env), value = T), \(.x)  {
  x <- get(.x, envir = env)
  x$provider <- gsub("_sources", "", .x)
  x[c("provider", "name", "source")]
}
))

readr::write_csv(src, "inst/bundle/gdalwebsrv.csv")
