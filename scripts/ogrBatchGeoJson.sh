# Bulk convert shapefiles to geojson using ogr2ogr
# For more information, see http://ben.balter.com/2013/06/26/how-to-convert-shapefiles-to-geojson-for-use-on-github/ for the basis of this script

# Note: Assumes you're in a folder with one or more zip files containing shape files
# and Outputs as geojson with the WGS84

#geojson conversion
function shp2geojson() {
  ogr2ogr -f GeoJSON -t_srs WGS84 "../../geoJSON/$1.geojson" "$1.shp"
}

#convert all shapefiles
for var in *.shp; do shp2geojson ${var%\.*}; done
mv *.geojson ../../geoJSON
