### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("code/parameters/rasterize.toml") as conffile:
	rasterize_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

### Main processing
# rasterize data
arcpy.PolygonToRaster_conversion(sys.argv[1], 'IUCN_CODE', sys.argv[2], rasterize_params['cell_assignment'], 'NONE', rasterize_params['cellsize'])

