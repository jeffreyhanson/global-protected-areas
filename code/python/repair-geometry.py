### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

# set wgs1984 parameters
min_lon = -180.0
max_lon = 180.0
min_lat = -90.0
max_lat = 90.0

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

### Main processing
# run repair geometry
arcpy.RepairGeometry_management(sys.argv[1])
arcpy.RepairGeometry_management(sys.argv[1])
arcpy.RepairGeometry_management(sys.argv[1])
arcpy.RepairGeometry_management(sys.argv[1])
