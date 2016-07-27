### Initialization
# load libraries
import arcpy
import toml
import os
import sys

### Preliminary processing
# load parameters
input_file = sys.argv[1]
output_file = sys.argv[2]

with open("general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("omit-areas.toml") as conffile:
	omit_areas_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
## parse expression
# parse fields in shapefile
file_fields = [file.name for file in arcpy.ListFields(input_file)]
for i in range(file_fields):
	file_fields[i] = file_fields[i].encode('utf8')
# loop over fields in toml file
expression=""
for omit_field in omit_areas_params.keys():
	# skip if title
	if omit_field=='title':
		next
	# parse field
	if omit_field.upper() in file_fields:
		omit_field
		expression+='"'+omit_field.upper()+'" NOT IN ('
		for value in omit_dict[omit_field]:
				expression+="'"+value"'"+','
		expression=expression[:-1]
		expression+=') AND '
	else:
		print 'warning: '+omit_field+' not in '+os.path.basename(input_file)
# remove trailing AND statement
expression=expression[:-5]
# if point file then remove points with rep_area==0
if arcpy.Describe(input_file).shapeType == 'Point':
	expression=expression+' AND "REP_AREA" > 0'

## execute select tool
arcpy.Select_analysis(input_file, output_file, expression)
