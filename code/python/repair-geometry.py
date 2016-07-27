### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
# run repair geometry
arcpy.RepairGeometry_management(sys.argv[1])
