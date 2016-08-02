### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

### Main processing
# get unique field values
field_values = set()
with arcpy.da.SearchCursor(sys.argv[1], sys.argv[2]) as rows:
	for row in rows:
		field_values.add(row[0])

# select data
for x in field_values:
	if isinstance(x, basestring):
		expr =  '"'+sys.argv[2]+'" = \''+x+'\''
	else:
		expr =  '"'+sys.argv[2]+'" = '+x
	arcpy.Select_analysis(sys.argv[1], sys.argv[3]+'/'+sys.argv[2]+'_'+x.replace(' ', '_'), expr)
