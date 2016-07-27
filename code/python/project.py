### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("project.toml") as conffile:
	project_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
arcpy.Project_management(sys.argv[1], sys.argv[2], out_coor_system = project_params[sys.argv[3])

