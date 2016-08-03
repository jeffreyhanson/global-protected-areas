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
# extract data from geodatabase
arcpy.CopyFeatures_management(
	'data/raw/WDPA_geodatabase/WDPA_'+current_date+'_Public/WDPA_'+current_date+'_Public.gdb/WDPA_'+sys.argv[1]+'_'+current_date,
	sys.argv[2]
)
