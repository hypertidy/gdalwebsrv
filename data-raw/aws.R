
files <- system.file("awswmsxml/aws-elevation-tiles-prod.xml", package = "gdalwebsrv")
aws_web_sources <- tibble::tibble(name = gsub("\\.xml$", "", basename(files)),
                                   file  = file.path(basename(dirname(files)), basename(files)))

usethis::use_data(aws_web_sources)
