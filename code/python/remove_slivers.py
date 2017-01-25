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

# storing system cmds
input_PTH = sys.argv[1]
output_PTH = sys.argv[2]

### Main processing
# calculate area
arcpy.AddField_management(input_PTH, 'AREA', 'DOUBLE')
arcpy.CalculateField_management(input_PTH, 'AREA', '!shape.area@SQUAREKILOMETERS!', 'PYTHON_9.3')


# select slivers
arcpy.MakeFeatureLayer_management(os.path.basename(input_PTH), os.path.basename(input_PTH)+'_layer')
arcpy.SelectLayerByAttribute_management(os.path.basename(input_PTH)+'_layer', "NEW_SELECTION", 'AREA < '+str(slivers_params['minimum_size_in_square_kilometers']))

# remove slivers 
arcpy.Eliminate_management (os.path.basename(input_PTH)+'_layer', output_PTH, slivers_params['selection'])
