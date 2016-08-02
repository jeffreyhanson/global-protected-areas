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
arcpy.env.parallelProcessingFactor = general_params['threads']
arcpy.env.overwriteOutput = True
arcpy.env.workspace = sys.argv[1]

# remove missing iucn categories from params
features = arcpy.ListFeatureClasses()
iucn_names = []
for x in iucn_params['IUCN_CAT']:
	name = 'IUCN_CAT_'+x.replace(' ' , '_')
	if name in features:	
		iucn_names.append(name)
iucn_names.reverse()

### Main processing
# initial update data
arcpy.Update_analysis(
	sys.argv[1]+'/'+iucn_names[0],
	sys.argv[1]+'/'+iucn_names[1], 
	sys.argv[2]+'/update_1'
)

# subsequent updates
counter = 1
for x in iucn_names[2:]:
	arcpy.Update_analysis(
		sys.argv[2]+'/update_'+str(counter),
		sys.argv[1]+'/'+x,
		sys.argv[2]+'/update_'+str(counter+1)	
	)
	counter = counter + 1

# export final dataset
arcpy.Copy_management(
	sys.argv[2]+'/update_'+str(counter),
	sys.argv[2]+'/'+sys.argv[3]
)

