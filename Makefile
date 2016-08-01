# main operation
all: WDPA.tif
	
# command to clean dirs
clean:
	@rm WDPA.tif
	@rm -rf data/raw/*
	@rm -rf data/intermediate/* 

# commands for creating final products
WDPA.tif: data/intermediate/11/WDPA.tif
	@echo "exporting data"
	@cp data/intermediate/11/WDPA.tif .

## commands for processing data
# convert to tif
data/intermediate/11/WDPA.tif: data/intermediate/10/WDPA_shapefile.gdb code/python/rasterize.py code/parameters/rasterize.toml code/parameters/general.toml
	@echo "rasterizing data"
	@mkdir -p data/intermediate/11
	@python code/python/rasterize.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/11/WDPA.tif"

# use successive updates to merge polygons
data/intermediate/10/WDPA_shapefile.gdb: data/intermediate/9/WDPA_shapefile.gdb code/python/update.py code/parameters/general.toml
	@echo "merging though successive updating data"
	@mkdir -p data/intermediate/10
	@python code/python/create-gdb.py "data/intermediate/10/WDPA_shapefile.gdb"
	@python code/python/update.py "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_10" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_9" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_8" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_7" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_6" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_5" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_4" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_3" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_2" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/update.py "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_1" "data/intermediate/10/WDPA_shapefile.gdb/WDPA_shapefile"

# dissolve separate iucn polygons
data/intermediate/9/WDPA_shapefile.gdb: data/intermediate/8/WDPA_shapefile.gdb code/python/dissolve.py code/parameters/general.toml
	@echo "dissolving data for each iucn category"
	@mkdir -p data/intermediate/9
	@python code/python/create-gdb.py "data/intermediate/9/WDPA_shapefile.gdb"	
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_1" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_1"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_2" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_2"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_3" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_3"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_4" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_4"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_5" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_5"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_6" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_6"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_7" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_7"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_8" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_8"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_9" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_9"
	@python code/python/dissolve.py "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_10" "IUCN_CODE" "data/intermediate/9/WDPA_shapefile.gdb/WDPA_shapefile_10"

# extract separate iucn polygons
data/intermediate/8/WDPA_shapefile.gdb: data/intermediate/7/WDPA_shapefile.gdb code/python/select.py code/parameters/general.toml
	@echo "seperating data for each iucn category"
	@mkdir -p data/intermediate/8
	@python code/python/create-gdb.py "data/intermediate/8/WDPA_shapefile.gdb"	
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "1" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_1"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "2" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_2"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "3"  "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_3"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "4" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_4"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "5" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_5"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "6" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_6"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "7" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_7"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "8" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_8"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "9" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_9"
	@python code/python/select.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "IUCN_CODE" "10" "data/intermediate/8/WDPA_shapefile.gdb/WDPA_shapefile_10"

# assign iucn codes
data/intermediate/7/WDPA_shapefile.gdb: data/intermediate/6/WDPA_shapefile.gdb code/python/assign_codes.py code/parameters/general.toml code/parameters/iucn-codes.toml
	@echo "assigning codes to data"
	@mkdir -p data/intermediate/7
	@python code/python/create-gdb.py "data/intermediate/7/WDPA_shapefile.gdb"	
	@python code/python/copy-data.py "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile"
	@python code/python/assign_codes.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile"

# merge point and polygons
data/intermediate/6/WDPA_shapefile.gdb: data/intermediate/4/WDPA_shapefile_polygons.gdb data/intermediate/5/WDPA_shapefile_points.gdb code/python/merge.py code/python/create-gdb.py code/parameters/general.toml
	@echo "merging point and polygon data"
	@mkdir -p data/intermediate/6
	@python code/python/create-gdb.py "data/intermediate/6/WDPA_shapefile.gdb"	
	@python code/python/merge.py "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/5/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile"

# prepare polygons
data/intermediate/4/WDPA_shapefile_polygons.gdb: data/intermediate/3/WDPA_shapefile_polygons.gdb code/python/simplify.py code/python/create-gdb.py code/parameters/simplify.toml code/parameters/general.toml
	@echo "simplifying polygon data"
	@mkdir -p data/intermediate/4
	@python code/python/create-gdb.py "data/intermediate/4/WDPA_shapefile_polygons.gdb"
	@python code/python/simplify.py "data/intermediate/3/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

# prepare points
data/intermediate/5/WDPA_shapefile_points.gdb: data/intermediate/4/WDPA_shapefile_points.gdb  code/python/create-gdb.py  code/python/project.py code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting point data again to match polygon data"
	@mkdir -p data/intermediate/5
	@python code/python/create-gdb.py "data/intermediate/5/WDPA_shapefile_points.gdb"
	@python code/python/project.py "data/intermediate/4/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/5/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "output_coordinate_reference_system"

data/intermediate/4/WDPA_shapefile_points.gdb: data/intermediate/3/WDPA_shapefile_points.gdb  code/python/create-gdb.py  code/python/buffer.py code/parameters/general.toml
	@echo "buffering point data"
	@mkdir -p data/intermediate/4
	@python code/python/create-gdb.py "data/intermediate/4/WDPA_shapefile_points.gdb"
	@python code/python/buffer.py "data/intermediate/3/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/4/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/3/WDPA_shapefile_polygons.gdb: data/intermediate/2/WDPA_shapefile_polygons.gdb code/python/project.py code/python/create-gdb.py code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting polygon data to output coordinate system"
	@mkdir -p data/intermediate/3
	@python code/python/create-gdb.py "data/intermediate/3/WDPA_shapefile_polygons.gdb"
	@python code/python/project.py "data/intermediate/2/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/3/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "output_coordinate_reference_system"

data/intermediate/3/WDPA_shapefile_points.gdb: data/intermediate/2/WDPA_shapefile_points.gdb code/python/project.py code/python/create-gdb.py code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting point data to distance coordinate system"
	@mkdir -p data/intermediate/3
	@python code/python/create-gdb.py "data/intermediate/3/WDPA_shapefile_points.gdb"
	@python code/python/project.py "data/intermediate/2/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/3/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "distance_coordinate_reference_system"

# omit areas that are not valid protected areas
data/intermediate/2/WDPA_shapefile_points.gdb: data/intermediate/1/WDPA_shapefile_points.gdb code/python/omit-areas.py code/python/create-gdb.py code/parameters/omit-areas.toml code/parameters/general.toml
	@echo "omitting invalid areas from point data"
	@mkdir -p data/intermediate/2
	@python code/python/create-gdb.py "data/intermediate/2/WDPA_shapefile_points.gdb"
	@python code/python/omit-areas.py "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/2/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/2/WDPA_shapefile_polygons.gdb: data/intermediate/1/WDPA_shapefile_polygons.gdb code/python/omit-areas.py code/python/create-gdb.py code/parameters/omit-areas.toml code/parameters/general.toml
	@echo "omitting invalid areas from polygon data"
	@mkdir -p data/intermediate/2
	@python code/python/create-gdb.py "data/intermediate/2/WDPA_shapefile_polygons.gdb"
	@python code/python/omit-areas.py "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/2/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

# repair any geometry issues in the data
data/intermediate/1/WDPA_shapefile_points.gdb: data/raw/WDPA_shapefile_points.gdb code/python/repair-geometry.py code/python/create-gdb.py code/python/copy-data.py code/parameters/general.toml
	@echo "repairing point data"
	@mkdir -p data/intermediate/1
	@python code/python/create-gdb.py "data/intermediate/1/WDPA_shapefile_points.gdb"
	@python code/python/copy-data.py "data/raw/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points"
	@python code/python/repair-geometry.py "data/intermediate/1/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/intermediate/1/WDPA_shapefile_polygons.gdb: data/raw/WDPA_shapefile_polygons.gdb code/python/repair-geometry.py code/python/create-gdb.py code/python/copy-data.py code/parameters/general.toml 
	@echo "repairing polygon data"
	@mkdir -p data/intermediate/1	
	@python code/python/create-gdb.py "data/intermediate/1/WDPA_shapefile_polygons.gdb"
	@python code/python/copy-data.py "data/raw/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"
	@python code/python/repair-geometry.py "data/intermediate/1/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"
	
# download and extract data
data/raw/WDPA_shapefile_points.gdb: data/raw/WDPA_geodatabase code/python/extract-data.py code/python/create-gdb.py code/parameters/general.toml
	@echo "extracting point data"
	@python code/python/create-gdb.py "data/raw/WDPA_shapefile_points.gdb"
	@python code/python/extract-data.py "point" "data/raw/WDPA_shapefile_points.gdb/WDPA_shapefile_points"

data/raw/WDPA_shapefile_polygons.gdb: data/raw/WDPA_geodatabase code/python/extract-data.py code/python/create-gdb.py code/parameters/general.toml
	@echo "extracting polygon data"
	@python code/python/create-gdb.py "data/raw/WDPA_shapefile_polygons.gdb"
	@python code/python/extract-data.py "poly" "data/raw/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

data/raw/WDPA_geodatabase: code/python/download-data.py
	@echo "downloading data"
	@python code/python/download-data.py

