## main operations
all: download process

# command to clean dirs
clean:
	@rm -rf data/raw/*
	@rm -rf data/intermediate/* 
	@rm -rf data/final/*

# commands for processing data
process:
	repair-data
	omit-areas
	simplify
	buffer-points
	merge-points-with-polygons
	dissolve
	rasterize
	export
	echo "processing complete."
	echo "data is stored in data/final "
	
export: data/intermediate/7/WDPA-shapefile*
	@cp data/intermediate/7/WDPA-shapefile* data/final/

rasterize: data/intermediate/6/WDPA-shapefile* code/python/07-rasterize.py code/parameters/rasterize.toml code/parameters/general.toml
	@mkdir data/intermediate/7
	@python code/python/07-dissolve.py > 07-dissolve.txt
	@mv *.txt data/intermediate/7

project: data/intermediate/5/WDPA-shapefile* code/python/06-project.py code/parameters/project.toml code/parameters/general.toml
	@mkdir data/intermediate/6
	@python code/python/06-project.py > 06-project.txt
	@mv *.txt data/intermediate/6/

dissolve: data/intermediate/4/WDPA-shapefile* code/python/05-dissolve.py code/parameters/general.toml
	@mkdir data/intermediate/5
	@python code/python/05-dissolve.py > 05-dissolve.txt
	@mv *.txt data/intermediate/5/

merge-points-with-polygons: data/intermediate/3/WDPA-shapefile* code/python/04-buffer-points-and-merge-data.py code/parameters/general.toml 
	@mkdir data/intermediate/4
	@python code/python/04-buffer-points-and-merge-data.py > 04-buffer-points-and-merge-data.txt
	@mv *.txt data/intermediate/4/

simplify: data/intermediate/2/WDPA-shapefile* code/python/04-simplify.py code/parameters/simplify.toml code/parameters/general.toml
	@mkdir data/intermediate/3
	@python code/python/03-simplify.py > 03-simplify.txt
	@mv *.txt data/intermediate/3/

omit-areas: data/intermediate/1/WDPA-shapefile* code/python/02-omit-areas.py code/parameters/omit-areas.toml code/parameters/general.toml
	@mkdir data/intermediate/2
	@python code/python/02-omit-areas.py
	@mv *.txt data/intermediate/2/

repair-data: data/raw/WDPA-shapefile* code/python/01-repair-geometry.py code/parameters/general.toml
	@mkdir data/intermediate/1
	@python code/01-repair-geometry.py > 01-repair-geometry.py
	@mv *.txt data/intermediate/1/

# command to download data
download: code/python/00-download-data.py
	@mkdir data/intermediate/0
	@python code/00-download-data.py > 00-download-data.txt
	@mv *.txt data/intermediate/0/






