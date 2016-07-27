# main operation
all:
	WDPA.tif
	
# command to clean dirs
clean:
	@rm -rf data/raw/*
	@rm -rf data/intermediate/* 

# commands for creating final products
WDPA.tif: data/intermediate/7/WDPA.tif
	@echo "exporting data"
	@cp data/intermediate/7/WDPA.tif .

# commands for processing data
data/intermediate/8/WDPA.tif: data/intermediate/8/WDPA-shapefile-dissolved.shp code/python/rasterize.py code/parameters/rasterize.toml code/parameters/general.toml
	@echo "rasterizing data"
	@mkdir data/intermediate/8
	@python code/python/rasterize.py "data/intermediate/7/WDPA-shapefile.shp" "data/intermediate/8/WDPA.tif" > rasterize.txt
	@mv rasterize.txt data/intermediate/8

data/intermediate/7/WDPA-shapefile.shp: data/intermediate/6/WDPA-shapefile.shp code/python/dissolve.py code/parameters/general.toml
	@echo "dissolving data"
	@mkdir data/intermediate/7
	@python code/python/dissolve.py "data/intermediate/6/WDPA-shapefile.shp" "data/intermediate/7/WDPA-shapefile.shp" > dissolve.txt
	@mv dissolve.txt data/intermediate/7

data/intermediate/6/WDPA-shapefile.shp: data/intermediate/4/WDPA-shapefile-polygons.shp data/intermediate/5/WDPA-shapefile-points.shp code/python/merge.py code/parameters/general.toml 
	@echo "merging point and polygon data"
	@mkdir data/intermediate/6
	@python merge.py "data/intermediate/4/WDPA-shapefile-polygons.shp" "data/intermediate/5/WDPA-shapefile-points.shp" > merge.txt
	@mv merge.txt data/intermediate/6

data/intermediate/4/WDPA-shapefile-polygons.shp: data/intermediate/3/WDPA-shapefile-polygons.shp code/python/simplify.py code/parameters/simplify.toml code/parameters/general.toml
	@echo "simplifying polygon data"
	@mkdir data/intermediate/4
	@python code/python/simplify.py "data/intermediate/3/WDPA-shapefile-polygons.shp" "data/intermediate/4/WDPA-shapefile-polygons.shp" > simplify-polygons.txt
	@mv simplify.txt data/intermediate/4

data/intermediate/5/WDPA-shapefile-points.shp: data/intermediate/4/WDPA-shapefile-points.shp code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting point data again to match polygon data"
	@mkdir data/intermediate/5
	@python code/python/.py "data/intermediate/4/WDPA-shapefile-points.shp" "data/intermediate/5/WDPA-shapefile-points.shp" "output_coordinate_reference_system" > project-points.txt
	@mv buffer.txt data/intermediate/5

data/intermediate/4/WDPA-shapefile-points.shp: data/intermediate/3/WDPA-shapefile-points.shp code/parameters/general.toml
	@echo "buffering point data"
	@mkdir data/intermediate/4
	@python code/python/buffer.py "data/intermediate/3/WDPA-shapefile-points.shp" "data/intermediate/4/WDPA-shapefile-points.shp" > buffer-points.txt
	@mv buffer.txt data/intermediate/4

data/intermediate/3/WDPA-shapefile-polygons.shp: data/intermediate/2/WDPA-shapefile-polygons.shp code/python/project.py code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting polygon data to output coordinate system"
	@mkdir data/intermediate/3
	@python code/python/project.py "data/intermediate/2/WDPA-shapefile-polygons.shp" "data/intermediate/3/WDPA-shapefile-polygons.shp" "output_coordinate_reference_system" > project-polygons.txt
	@mv project-polygons.txt data/intermediate/3

data/intermediate/3/WDPA-shapefile-points.shp: data/intermediate/2/WDPA-shapefile-points.shp code/python/project.py code/parameters/project.toml code/parameters/general.toml
	@echo "reprojecting point data to distance coordinate system"
	@mkdir data/intermediate/3
	@python code/python/project.py "data/intermediate/2/WDPA-shapefile-points.shp" "data/intermediate/3/WDPA-shapefile-points.shp" "distance_coordinate_reference_system" > project-points.txt
	@mv project-points.txt data/intermediate/3

data/intermediate/2/WDPA-shapefile-points.shp: data/intermediate/1/WDPA-shapefile-points.shp code/python/omit-areas.py code/parameters/omit-areas.toml code/parameters/general.toml
	@echo "omitting invalid areas from point data"
	@mkdir data/intermediate/2
	@python code/python/omit-areas.py "data/intermediate/1/WDPA-shapefile-points.shp" "data/intermediate/2/WDPA-shapefile-points.shp" > omit-areas-points.txt
	@mv omit-areas-points.txt data/intermediate/2

data/intermediate/2/WDPA-shapefile-polygons.shp: data/intermediate/1/WDPA-shapefile-polygons.shp code/python/omit-areas.py code/parameters/omit-areas.toml code/parameters/general.toml
	@echo "omitting invalid areas from polygon data"
	@mkdir data/intermediate/2
	@python code/python/omit-areas.py "data/intermediate/1/WDPA-shapefile-polygons.shp" "data/intermediate/2/WDPA-shapefile-polygons.shp" > omit-areas-polygons.txt
	@mv omit-areas-polygons.txt data/intermediate/2

data/intermediate/1/WDPA-shapefile-points.shp: data/raw/WDPA-shapefile code/python/repair-geometry.py code/parameters/general.toml
	@echo "repairing point data"
	@mkdir data/intermediate/1
	@cp data/raw/WDPA-shapefile/WDPA-shapefile-points* data/intermediate/1
	@python code/repair-geometry.py "data/intermediate/1/WDPA-shapefile-points.shp" > repair-geometry-points.txt
	@mv repair-geometry-points.txt data/intermediate/1

data/intermediate/1/WDPA-shapefile-polygons.shp: data/raw/WDPA-shapefile code/python/repair-geometry.py code/parameters/general.toml
	@echo "repairing polygon data"
	@mkdir data/intermediate/1
	@cp data/raw/WDPA-shapefile/WDPA-shapefile-polygons* data/intermediate/1
	@python code/repair-geometry.py "data/intermediate/1/WDPA-shapefile-polygons.shp" > repair-geometry-polygons.txt
	@mv repair-geometry-polygons.txt.txt data/intermediate/1

# command to download and extract data
data/raw/WDPA-shapefile: code/python/download-data.py
	@echo "downloading data"
	@python code/download-data.py > download-data.txt
	@mv download-data.txt data/raw

