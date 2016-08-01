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
arcpy.env.overwriteOutput = True

### Main processing
## parse expression
# parse fields in shapefile
file_fields = [file.name for file in arcpy.ListFields(sys.argv[1])]
for i in range(len(file_fields)):
	file_fields[i] = file_fields[i].encode('utf8')

# loop over fields in toml file
expression=""
if 'omit data' in omit_areas_params.keys():
	omit_fields = omit_areas_params['omit data']
	for omit_field in omit_fields.keys():
		# parse field
		if omit_field in file_fields:
			if len(omit_fields[omit_field]) > 1:
				expression+='"'+omit_field+'" NOT IN ('
				for value in omit_fields[omit_field]:
						expression+="'"+value+"'"+','
				expression=expression[:-1]
				expression+=') AND '
			else:
				expression+='"'+omit_field+'" <> '+"'"+omit_fields[omit_field][0]+"' AND "
		else:
			raise ValueError(omit_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
if 'select data' in omit_areas_params.keys():
	select_fields = omit_areas_params['select data']
	for select_field in select_fields:
		# parse field
		if select_field in file_fields:
			if len(select_fields[select_field]) > 1:
				expression+='"'+select_field+'" IN ('
				for value in select_fields[select_field]:
						expression+="'"+value+"'"+','
				expression=expression[:-1]
				expression+=') AND '
			else:
				expression+='"'+select_field+'" = '+"'"+select_fields[select_field][0]+"' AND "
		else:
			raise ValueError(select_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
# remove trailing AND statement
expression=expression[:-5]
# if point file then remove points with rep_area==0
if arcpy.Describe(sys.argv[1]).shapeType == 'Point':
	expression=expression+' AND "REP_AREA" > 0'

## execute select tool
arcpy.Select_analysis(sys.argv[1], sys.argv[2], expression)
