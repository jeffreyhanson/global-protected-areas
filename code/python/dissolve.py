### Initialization
# load libraries
import arcpy
import toml

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())
with open("code/parameters/dissolve.toml") as conffile:
	dissolve_params = toml.loads(conffile.read())

# set environmental variables
arcpy.env.parallelProcessingFactor=general_params['threads']

### Main processing
# copy data
for file in glob.glob('data/intermediate/05/WDPA-shapefile*')
	shutil.copy2(file, 'data/intermediate/06')

# create new column for integer codes for IUCN criteria
arcpy.AddField_management('data/intermediate/06/WDPA-shapefile.shp', 'IUCN_CODE', 'INTEGER')

# assign integer values based on IUCN critera
arcpy.CalculateField_management('data/intermediate/06/WDPA-shapefile.shp', 'IUCN_CODE', 
'def get_iucn_code(!IUCN_CAT!)', "
	def get_iucn_code(i):
		iucn_cats=['Ia', 'Ib', 'II', 'III', 'IV', 'V', 'VI', 'Not Assigned', 'Not Applicable', 'Not Reported']
		return(iucn_cats.index(i))
", 'PYTHON_9.3'
)

# dissolve data
arcpy.Dissolve_management(
	'data/intermediate/06/WDPA-shapefile.shp', 'data/intermediate/06/WDPA-shapefile-dissolved.shp',
	dissolve_field='IUCN_CODE', statistics_fields=[['IUCN_CODE', 'MIN']]
)

