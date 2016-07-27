### Initialization
# load libraries
import arcpy
import toml

### Preliminary processing
# load parameters
with open("general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("project.toml") as conffile:
	project_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing

# merge with polygons
arcpy.Merge_management(
	['data/intermediate/05/WDPA-shapefile-points-buffered-projected.shp', 'data/intermediate/04/WDPA-shapefile-polygons.shp'],
	'data/intermediate/05/WDPA-shapefile'
)



 
