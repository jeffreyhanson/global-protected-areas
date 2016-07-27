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
with open("code/parameters/omit-areas.toml") as conffile:
	omit_areas_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
## parse expression
# parse fields in shapefile
file_fields = [file.name for file in arcpy.ListFields(sys.argv[1])]
for i in range(len(file_fields)):
	file_fields[i] = file_fields[i].encode('utf8')
# loop over fields in toml file
expression=""
for omit_field in omit_areas_params.keys():
	# skip if title
	if omit_field=='title':
		continue
	# parse field
	if omit_field.upper() in file_fields:
		omit_field
		expression+='"'+omit_field.upper()+'" NOT IN ('
		for value in omit_areas_params[omit_field]:
				expression+="'"+value+"'"+','
		expression=expression[:-1]
		expression+=') AND '
	else:
		raise ValueError(omit_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
# remove trailing AND statement
expression=expression[:-5]
# if point file then remove points with rep_area==0
if arcpy.Describe(sys.argv[1]).shapeType == 'Point':
	expression=expression+' AND "REP_AREA" > 0'

## execute select tool
arcpy.Select_analysis(sys.argv[1], sys.argv[2], expression)
