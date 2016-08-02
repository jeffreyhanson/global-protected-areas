### Initialization
# load libraries
import arcpy
import toml
import os
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

### Main processing
# create gdb
if not sys.argv[1].endswith('.shp') and not sys.argv[2].endswith('.shp'):
	arcpy.Copy_management(sys.argv[1], sys.argv[2])
else:
	arcpy.CopyFeatures_management(sys.argv[1], sys.argv[2])
