tasmap_sources <- tibble::tribble(
  ~name, ~source,
  "TTSA",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Raster/TTSA/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Raster_TTSA,tilematrixset=default028mm",
  "ESgisMapBookPUBLIC",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/ESgisMapBookPUBLIC/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_ESgisMapBookPUBLIC,tilematrixset=default028mm",
  "HillshadeGrey",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/HillshadeGrey/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_HillshadeGrey,tilematrixset=default028m",
  "Tasmap250K",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/Tasmap250K/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_Tasmap250K,tilematrixset=default028mm",
  "Topographic",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/Topographic/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_Topographic,tilematrixset=default028mm",
  "Orthophoto",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/Orthophoto/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_Orthophoto,tilematrixset=default028mm",
  "Hillshade",
    "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/Hillshade/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_Hillshade,tilematrixset=default028mm",
  "TasmapRaster",
  "WMTS:https://services.thelist.tas.gov.au/arcgis/rest/services/Basemaps/TasmapRaster/MapServer/WMTS/1.0.0/WMTSCapabilities.xml,layer=Basemaps_TasmapRaster,tilematrixset=default028mm"


)


## see mdsumner/tasmapr for using these as leaflet sources
