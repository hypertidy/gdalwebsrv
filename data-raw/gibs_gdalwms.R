gdal_wms <- vapour::vapour_sds_names("WMS:https://gibs.earthdata.nasa.gov/twms/epsg3857/best/twms.cgi?request=GetTileService")
names <- unlist(strsplit(unlist(lapply(strsplit(gdal_wms$subdataset, "<TiledGroupName>"), "[[", 2)), "</TiledGroupName></Service></GDAL_WMS>"))
gibs_sources <- tibble(name = names, source = gdal_wms$subdataset)
