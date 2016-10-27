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
if 'omit character data' in omit_areas_params.keys():
	omit_fields = omit_areas_params['omit character data']
	for omit_field in omit_fields.keys():
		# parse field
		if omit_field in file_fields:
			if omit_fields[omit_field].__class__.__name__ == 'list':
				if len(omit_fields[omit_field]) > 1:
					expression+='"'+omit_field+'" NOT IN ('
					for value in omit_fields[omit_field]:
							expression+="'"+value+"'"+','
					expression=expression[:-1]
					expression+=') AND '
				else:
					expression+='"'+omit_field+'" <> '+"'"+omit_fields[omit_field][0]+"' AND "
			elif omit_fields[omit_field].__class__.__name__ == 'str':
				expression+='"'+omit_field+'" <> '+"'"+omit_fields[omit_field]+"' AND "
			else:
				raise ValueError(omit_field+' in omit-areas.toml in '+os.path.basename(sys.argv[1]) + 'has invalid format')					
		else:
			raise ValueError(omit_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
if 'select character data' in omit_areas_params.keys():
	select_fields = omit_areas_params['select character data']
	for select_field in select_fields:
		# parse field
		if select_field in file_fields:
			if select_fields[select_field].__class__.__name__ == 'list':				
				if len(select_fields[select_field]) > 1:
					expression+='"'+select_field+'" IN ('
					for value in select_fields[select_field]:
							expression+="'"+value+"'"+','
					expression=expression[:-1]
					expression+=') AND '
				else:
					expression+='"'+select_field+'" = '+"'"+select_fields[select_field][0]+"' AND "
			elif select_fields[select_field].__class__.__name__ == 'str':
				expression+='"'+select_field+'" = '+"'"+select_fields[select_field]+"' AND "
			else:
				raise ValueError(select_field+' in omit-areas.toml in '+os.path.basename(sys.argv[1]) + 'has invalid format')
		else:
			raise ValueError(select_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
if 'select numeric data' in omit_areas_params.keys():
	select_fields = omit_areas_params['select numeric data']
	for select_field in select_fields:
		# parse field
		if select_field in file_fields:
			expression+='"'+select_field+'" '+select_fields[select_field]+" AND "
		else:
			raise ValueError(select_field+' in omit-areas.toml not in '+os.path.basename(sys.argv[1]))
if 'omit numeric data' in omit_areas_params.keys():
	raise ValueError("['omit numeric data'] is not supported. Please use ['select numeric data instead']")

# remove trailing AND statement
expression=expression[:-5]
# if point file then remove points with rep_area==0
if arcpy.Describe(sys.argv[1]).shapeType == 'Point':
	expression=expression+' AND "REP_AREA" > 0'

## execute select tool
arcpy.Select_analysis(sys.argv[1], sys.argv[2], expression)
