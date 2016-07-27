### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("code/parameters/simplify.toml") as conffile:
	simplify_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
arcpy.SimplifyPolygon_cartography(
	sys.argv[1], sys.argv[2],
	algorithm=simplify_params['algorithm'], tolerance=simplify_params['tolerance'], minimum_area=simplify_params['minimum_area'], 
	error_option=simplify_params['error_option'], collapsed_point_option=simplify_params['collapsed_point_option']
)




 
