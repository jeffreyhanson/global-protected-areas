### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# checkout sa
arcpy.CheckOutExtension("Spatial")

# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("code/parameters/project.toml") as conffile:
	project_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

### Main processing
arcpy.Merge_management(sys.argv[1:2], sys.argv[3])



 
