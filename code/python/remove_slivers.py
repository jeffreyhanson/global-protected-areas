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

with open("code/parameters/remove-slivers.toml") as conffile:
	slivers_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True
arcpy.env.workspace = os.path.dirname(sys.argv[1])

### Main processing
# calculate area
arcpy.AddField_management(sys.argv[1], 'AREA', 'DOUBLE')
arcpy.CalculateField_management(sys.argv[1], 'AREA', '!shape.area@SQUAREKILOMETERS!', 'PYTHON_9.3')

# select slivers
arcpy.MakeFeatureLayer_management(os.path.basename(sys.argv[1]), os.path.basename(sys.argv[1])+'_layer')
arcpy.SelectLayerByAttribute_management(os.path.basename(sys.argv[1])+'_layer', "NEW_SELECTION", 'AREA < '+str(slivers_params['minimum_size_in_square_kilometers']))

# remove slivers 
arcpy.Eliminate_management (os.path.basename(sys.argv[1])+'_layer', sys.argv[2], slivers_params['selection'])
