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
arcpy.env.workspace = sys.argv[1]

### Main processing
# get list of data in gdb
features = arcpy.ListFeatureClasses()

# dissolve data
for x in features:
	arcpy.Dissolve_management(sys.argv[1]+'/'+x, sys.argv[3]+'/'+x, sys.argv[2], multi_part='SINGLE_PART')
