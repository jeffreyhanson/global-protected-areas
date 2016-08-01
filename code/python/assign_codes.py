### Initialization
# load libraries
import arcpy
import toml
import sys

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("code/parameters/iucn-codes.toml") as conffile:
	iucn_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']
arcpy.env.overwriteOutput = True

# create string with iucn codes
iucn_order=""
for i in iucn_params['IUCN_CAT']:
	iucn_order+="'"+i+"',"
iucn_order=iucn_order[:-1]

### Main processing
# create new column for integer codes for IUCN criteria
arcpy.AddField_management(sys.argv[1], 'IUCN_CODE', 'INTEGER')

# assign integer values based on IUCN criteria
arcpy.CalculateField_management(sys.argv[1], 'IUCN_CODE', 'get_iucn_code(!IUCN_CAT!)', 'PYTHON_9.3',
"def get_iucn_code(i):\n\tiucn_cats=["+iucn_order+"]\n\treturn(iucn_cats.index(i))\n"
)
