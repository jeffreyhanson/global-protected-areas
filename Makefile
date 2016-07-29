# main operation
all: WDPA.tif
	
# command to clean dirs
clean:
	@rm WDPA.tif
	@rm -rf data/raw/*
	@rm -rf data/intermediate/* 

# commands for creating final products
WDPA.tif: data/intermediate/8/WDPA.tif
	@echo "exporting data"
	@cp data/intermediate/8/WDPA.tif .

# commands for processing data
data/intermediate/8/WDPA.tif: data/intermediate/7/WDPA_shapefile.gdb code/python/rasterize.py code/parameters/rasterize.toml code/parameters/general.toml
	@echo "rasterizing data"
	@mkdir -p data/intermediate/8
	@python code/python/rasterize.py "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/8/WDPA.tif"

data/intermediate/7/WDPA_shapefile.gdb: data/intermediate/6/WDPA_shapefile.gdb code/python/dissolve.py code/python/create-gdb.py code/parameters/general.toml code/python/create-gdb.py
	@echo "dissolving data"
	@mkdir -p data/intermediate/7
	@python code/python/create-gdb.py "data/intermediate/7/WDPA_shapefile.gdb"	
	@python code/python/dissolve.py "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile" "data/intermediate/7/WDPA_shapefile.gdb/WDPA_shapefile"

data/intermediate/6/WDPA_shapefile.gdb: data/intermediate/4/WDPA_shapefile_polygons.gdb data/intermediate/5/WDPA_shapefile_points.gdb code/python/merge.py code/python/create-gdb.py code/parameters/general.toml
	@echo "merging point and polygon data"
	@mkdir -p data/intermediate/6
	@python code/python/create-gdb.py "data/intermediate/6/WDPA_shapefile.gdb"	
	@python code/python/merge.py "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/5/WDPA_shapefile_points.gdb/WDPA_shapefile_points" "data/intermediate/6/WDPA_shapefile.gdb/WDPA_shapefile"

data/intermediate/4/WDPA_shapefile_polygons.gdb: data/intermediate/3/WDPA_shapefile_polygons.gdb code/python/simplify.py code/python/create-gdb.py code/parameters/simplify.toml code/parameters/general.toml
	@echo "simplifying polygon data"
	@mkdir -p data/intermediate/4
	@python code/python/create-gdb.py "data/intermediate/4/WDPA_shapefile_polygons.gdb"
	@python code/python/simplify.py "data/intermediate/3/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons" "data/intermediate/4/WDPA_shapefile_polygons.gdb/WDPA_shapefile_polygons"

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
	
# command to download and extract data
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

