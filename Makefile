# main operation
all: geotiff shapefile
	
# command to clean dirs
clean: code/python/delete-dir.py code/python/delete-files.py code/python/new-file.py
	@python code/python/delete-files.py "WDPA*"
	@python code/python/delete-dir.py data/raw
	@python code/python/create-dir.py data/raw
	@python code/python/new-file.py data/raw/.gitkeep
	@python code/python/delete-dir.py data/intermediate
	@python code/python/create-dir.py data/intermediate
	@python code/python/new-file.py data/intermediate/.gitkeep

# commands for creating final products
geotiff: data/intermediate/12/WDPA.tif code/python/copy-file.py
	@echo "exporting geotiff data"
	@python code/python/copy-file.py data/intermediate/12/WDPA.tif WDPA.tif

shapefile: data/intermediate/12/WDPA.shp code/python/copy-file.py
	@echo "exporting shapefile data"
	@python code/python/copy-file.py data/intermediate/12/WDPA.shp WDPA.shp 
	@python code/python/copy-file.py data/intermediate/12/WDPA.shx WDPA.shx
	@python code/python/copy-file.py data/intermediate/12/WDPA.cpg WDPA.cpg
	@python code/python/copy-file.py data/intermediate/12/WDPA.dbf WDPA.dbf
	@python code/python/copy-file.py data/intermediate/12/WDPA.sbn WDPA.sbn
	@python code/python/copy-file.py data/intermediate/12/WDPA.prj WDPA.prj

## commands for processing data
# extract shapefile
data/intermediate/12/WDPA.shp: data/intermediate/10/WDPA_shapefile.gdb code/python/create-dir.py
	@echo "converting data to shapefile"
	@python code/python/create-dir.py "data/intermediate/12"
	@python code/python/copy-data.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/12/WDPA.shp"

# convert to tif
data/intermediate/12/WDPA.tif: data/intermediate/11/WDPA_shapefile.gdb code/python/rasterize.py code/parameters/rasterize.toml code/parameters/general.toml code/python/create-dir.py
	@echo "converting data to raster format"
	@python code/python/create-dir.py "data/intermediate/12"
	@python code/python/rasterize.py "data/intermediate/11/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/12/WDPA.tif" code/python/create-dir.py

# assign iucn codes
data/intermediate/11/WDPA_shapefile.gdb: data/intermediate/10/WDPA_shapefile.gdb code/python/assign_codes.py code/parameters/general.toml code/parameters/iucn-codes.toml code/python/create-dir.py
	@echo "assigning codes to data"
	@python code/python/create-dir.py "data/intermediate/11"
	@python code/python/create-gdb.py "data/intermediate/11/WDPA_shapefile.gdb"	
	@python code/python/copy-data.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/11/WDPA_shapefile.gdb/WDPA_shapefile" code/python/create-dir.py
	@python code/python/assign_codes.py "data/intermediate/11/WDPA_shapefile.gdb/WDPA_shapefile"

# remove slivers
data/intermediate/10/WDPA_shapefile.gdb: data/intermediate/9/WDPA_shapefile.gdb code/python/remove_slivers.py code/parameters/general.toml code/parameters/remove-slivers.toml code/python/create-dir.py
	@echo "removing slivers from data"
	@python code/python/create-dir.py "data/intermediate/10"
	@python code/python/create-gdb.py "data/intermediate/10/WDPA_shapefile.gdb"	
	@python code/python/multipart-to-singlepart.py "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/10/WDPA_shapefile.gdb/temp"
	@python code/python/remove_slivers.py "data/intermediate/10/WDPA_shapefile.gdb/temp" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	
# use successive updates to merge polygons
data/intermediate/9/WDPA_shapefile.gdb: data/intermediate/8/WDPA_shapefile.gdb code/python/successive_update.py code/parameters/general.toml code/parameters/iucn-codes.toml code/python/create-dir.py
	@echo "merging though successive updating data"
	@python code/python/create-dir.py "data/intermediate/9"
	@python code/python/create-gdb.py "data/intermediate/9/WDPA_shapefile.gdb"
	@python code/python/successive_update.py "data/intermediate/8/WDPA_shapefile.gdb" "data/intermediate/9/WDPA_shapefile.gdb" "WDPA_shapefile"

# dissolve separate iucn polygons
data/intermediate/8/WDPA_shapefile.gdb: data/intermediate/7/WDPA_shapefile.gdb code/python/dissolve_each.py code/parameters/general.toml code/python/create-dir.py
	@echo "dissolving data for each iucn category"
	@python code/python/create-dir.py "data/intermediate/8"
	@python code/python/create-gdb.py "data/intermediate/8/WDPA_shapefile.gdb"	
	@python code/python/dissolve_each.py "data/intermediate/7/WDPA_shapefile.gdb" "IUCN_CAT" "data/intermediate/8/WDPA_shapefile.gdb"

# extract separate iucn polygons
data/intermediate/7/WDPA_shapefile.gdb: data/intermediate/6/WDPA_shapefile.gdb code/python/select_each.py code/parameters/general.toml code/python/create-dir.py
	@echo "seperating data for each iucn category"
	@python code/python/create-dir.py "data/intermediate/7"
	@python code/python/create-gdb.py "data/intermediate/7/WDPA_shapefile.gdb"
	@python code/python/select_each.py "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CAT" "data/intermediate/7/WDPA_shapefile.gdb" code/python/create-dir.py

# merge point and polygons
data/intermediate/6/WDPA_shapefile.gdb: data/intermediate/4/WDPA_shapefile_polygons.gdb data/intermediate/5/WDPA_shapefile_points.gdb code/python/merge.py code/python/create-gdb.py code/parameters/general.toml code/python/create-dir.py
	@echo "merging point and polygon data"
	@python code/python/create-dir.py "data/intermediate/6"
	@python code/python/create-gdb.py "data/intermediate/6/WDPA_shapefile.gdb"	
	@python code/python/merge.py "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/5/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile"

# prepare polygons
data/intermediate/4/WDPA_shapefile_polygons.gdb: data/intermediate/3/WDPA_shapefile_polygons.gdb code/python/simplify.py code/python/create-gdb.py code/parameters/simplify.toml code/parameters/general.toml code/python/create-dir.py
	@echo "simplifying polygon data"
	@python code/python/create-dir.py "data/intermediate/4"
	@python code/python/create-gdb.py "data/intermediate/4/WDPA_shapefile_polygons.gdb"
	@python code/python/simplify.py "data/intermediate/3/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

data/intermediate/3/WDPA_shapefile_polygons.gdb: data/intermediate/2/WDPA_shapefile_polygons.gdb code/python/project.py code/python/create-gdb.py code/parameters/project.toml code/parameters/general.toml code/python/create-dir.py
	@echo "reprojecting polygon data to output coordinate system"
	@python code/python/create-dir.py "data/intermediate/3"
	@python code/python/create-gdb.py "data/intermediate/3/WDPA_shapefile_polygons.gdb"
	@python code/python/project.py "data/intermediate/2/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/3/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "output_coordinate_reference_system"

# prepare points
data/intermediate/5/WDPA_shapefile_points.gdb: data/intermediate/4/WDPA_shapefile_points.gdb  code/python/create-gdb.py  code/python/project.py code/parameters/project.toml code/parameters/general.toml code/python/create-dir.py
	@echo "reprojecting point data again to match polygon data"
	@python code/python/create-dir.py "data/intermediate/5"
	@python code/python/create-gdb.py "data/intermediate/5/WDPA_shapefile_points.gdb"
	@python code/python/project.py "data/intermediate/4/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/5/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "output_coordinate_reference_system"

data/intermediate/4/WDPA_shapefile_points.gdb: data/intermediate/3/WDPA_shapefile_points.gdb  code/python/create-gdb.py  code/python/buffer.py code/parameters/general.toml code/python/create-dir.py
	@echo "buffering point data"
	@python code/python/create-dir.py "data/intermediate/4"
	@python code/python/create-gdb.py "data/intermediate/4/WDPA_shapefile_points.gdb"
	@python code/python/buffer.py "data/intermediate/3/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/4/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/3/WDPA_shapefile_points.gdb: data/intermediate/2/WDPA_shapefile_points.gdb code/python/project.py code/python/create-gdb.py code/parameters/project.toml code/parameters/general.toml code/python/create-dir.py
	@echo "reprojecting point data to distance coordinate system"
	@python code/python/create-dir.py "data/intermediate/3"
	@python code/python/create-gdb.py "data/intermediate/3/WDPA_shapefile_points.gdb"
	@python code/python/project.py "data/intermediate/2/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/3/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "distance_coordinate_reference_system"

# omit areas that are not valid protected areas
data/intermediate/2/WDPA_shapefile_points.gdb: data/intermediate/1/WDPA_shapefile_points.gdb code/python/omit-areas.py code/python/create-gdb.py code/parameters/omit-areas.toml code/parameters/general.toml code/python/create-dir.py
	@echo "omitting invalid areas from point data"
	@python code/python/create-dir.py "data/intermediate/2"
	@python code/python/create-gdb.py "data/intermediate/2/WDPA_shapefile_points.gdb"
	@python code/python/omit-areas.py "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/2/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/2/WDPA_shapefile_polygons.gdb: data/intermediate/1/WDPA_shapefile_polygons.gdb code/python/omit-areas.py code/python/create-gdb.py code/parameters/omit-areas.toml code/parameters/general.toml code/python/create-dir.py
	@echo "omitting invalid areas from polygon data"
	@python code/python/create-dir.py "data/intermediate/2"
	@python code/python/create-gdb.py "data/intermediate/2/WDPA_shapefile_polygons.gdb"
	@python code/python/omit-areas.py "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/2/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

# repair any geometry issues in the data
data/intermediate/1/WDPA_shapefile_points.gdb: data/raw/WDPA_shapefile_points.gdb code/python/repair-geometry.py code/python/create-gdb.py code/python/copy-data.py code/parameters/general.toml code/python/create-dir.py
	@echo "repairing point data"
	@python code/python/create-dir.py "data/intermediate/1"
	@python code/python/create-gdb.py "data/intermediate/1/WDPA_shapefile_points.gdb"
	@python code/python/copy-data.py "data/raw/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points"
	@python code/python/repair-geometry.py "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/1/WDPA_shapefile_polygons.gdb: data/raw/WDPA_shapefile_polygons.gdb code/python/repair-geometry.py code/python/create-gdb.py code/python/copy-data.py code/parameters/general.toml code/python/create-dir.py
	@echo "repairing polygon data"
	@python code/python/create-dir.py "data/intermediate/1"
	@python code/python/create-gdb.py "data/intermediate/1/WDPA_shapefile_polygons.gdb"
	@python code/python/copy-data.py "data/raw/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"
	@python code/python/repair-geometry.py "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"
	
# download and extract data
data/raw/WDPA_shapefile_points.gdb: data/raw/WDPA_geodatabase code/python/extract-data.py code/python/create-gdb.py code/parameters/general.toml
	@echo "extracting point data"
	@python code/python/create-gdb.py "data/raw/WDPA_shapefile_points.gdb"
	@python code/python/extract-data.py "poin" "data/raw/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/raw/WDPA_shapefile_polygons.gdb: data/raw/WDPA_geodatabase code/python/extract-data.py code/python/create-gdb.py code/parameters/general.toml
	@echo "extracting polygon data"
	@python code/python/create-gdb.py "data/raw/WDPA_shapefile_polygons.gdb"
	@python code/python/extract-data.py "poly" "data/raw/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

data/raw/WDPA_geodatabase: code/python/download-data.py
	@echo "downloading data"
	@python code/python/download-data.py

