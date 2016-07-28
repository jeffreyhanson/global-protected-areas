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
# create new column for integer codes for IUCN criteria
arcp?y.AddField_management(sys.argv[1], 'IUCN_CODE', 'INTEGER')

# assign integer values based on IUCN criteria
arcpy.CalculateField_management(sys.argv[1], 'IUCN_CODE', 'get_iucn_code(!IUCN_CAT!)', 'PYTHON_9.3',
"""
def get_iucn_code(i):
	iucn_cats=['Ia', 'Ib', 'II', 'III', 'IV', 'V', 'VI', 'Not Assigned', 'Not Applicable', 'Not Reported']
	return(iucn_cats.index(i))
"""
)

# dissolve data
arcpy.Dissolve_management(
	sys.argv[1],sys.argv[2], 'IUCN_CODE', [['IUCN_CODE', 'MIN']], 'SINGLE_PART'
)

