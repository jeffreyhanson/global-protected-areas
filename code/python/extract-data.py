### Initialization
# load libraries
import arcpy
import os
import sys
import datetime
import toml

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

# get date string
current_date=os.listdir('data/raw/WDPA_geodatabase')[0].split('_')[1]

### Main processing
# get input geodatabase path
input_gdb_PTH = 'data/raw/WDPA_geodatabase'
input_gdb_PTH += '/' + os.listdir(input_gdb_PTH)[0]
for x in os.listdir(input_gdb_PTH):
	if x.endswith('.gdb'):
		input_gdb_PTH += '/' + x
		break
if not input_gdb_PTH.endswith('.gdb'):
	raise Exception('No .gdb file found in "data/raw/WDPA_geodatabase"')

# find layer inside geodatabase
arcpy.env.workspace = input_gdb_PTH
input_features = arcpy.ListFeatureClasses()
input_feature = ""
for x in input_features:
	if str(sys.argv[1]).lower() in str(x).lower():
		input_feature=str(x)
		break
if input_feature=="":
	raise Exception('No matching feature inside "'+input_gdb_PTH+'"')

# extract data from geodatabase
arcpy.CopyFeatures_management(
	input_gdb_PTH + '/' + input_feature,
	sys.argv[2]
)
