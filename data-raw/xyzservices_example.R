## assuming we are in hypertidy/gdalwebsrv/
source("data-raw/xyzservices.R")
gwms <- '<GDAL_WMS>
  <Service name="TMS">
    <ServerUrl>{url}</ServerUrl>
    </Service>
    <DataWindow>
    <UpperLeftX>{xmin}</UpperLeftX>
    <UpperLeftY>{ymax}</UpperLeftY>
    <LowerRightX>{xmax}</LowerRightX>
    <LowerRightY>{ymin}</LowerRightY>
    <TileLevel>{max_zoom}</TileLevel>
    <TileCountX>1</TileCountX>
    <TileCountY>1</TileCountY>
    <YOrigin>top</YOrigin>
    </DataWindow>
    <Projection>EPSG:3857</Projection>
     <BlockSizeX>{tileSize}</BlockSizeX>
    <BlockSizeY>{tileSize}</BlockSizeY>
    <BandsCount>3</BandsCount>
    <UserAgent>Mozilla/5.0</UserAgent>

    <Cache />
    </GDAL_WMS>'

maxex <- 20037508.34
# xyzservices <- xyzservices %>%
#   mutate(xmin = replace_na(xmin, -maxex),
#          xmax = replace_na(xmax, maxex),
#          ymin = replace_na(ymin, -maxex),
#          ymax = replace_na(ymax, maxex)
#          )


g <- list(extent = c(-1, 1, -1, 1) * maxex,
          dimension = c(1024, 1024) /8,
          projection = "EPSG:3857")
gdalio::gdalio_set_default_grid(g)

xyzservices$tileSize[is.na(xyzservices$tileSize)] <- 256
xyzservices <- filter(xyzservices, is.na(xmin) & is.na(status) & !grepl("insert", url ))


par(mar = rep(0, 4)) #, mfrow = n2mfrow(sum(xyzservices$good)))
xyzservices$good <- FALSE

for (i in seq_len(nrow(xyzservices))) {
 #if (!xyzservices$good[i]) next;
  this0 <- xyzservices[i, ]  %>%
     mutate(url = gsub("\\{", "\\$\\{", url))
  xml <- with(this0, glue::glue(gwms))

  g1 <- list(extent = unlist(select(this0, xmin, xmax, ymin, ymax), use.names = F),
            dimension = c(512, 512)/4,
            projection = "EPSG:3857")
  gdalio::gdalio_set_default_grid(g1)


  r <- try(gdalio::gdalio_graphics(xml), silent = TRUE)
  if (!inherits(r, "try-error") && length(unique(r)) > 1) {
    xyzservices$good[i] <- TRUE
    plot(r)
  }
  gdalio::gdalio_set_default_grid(g)

}




