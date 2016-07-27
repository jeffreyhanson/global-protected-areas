### Initialization
# load libraries
import arcpy
import toml
import wget
import datetime
import zipfile

# define parameters
now=datetime.datetime.now()
url='http://www.protectedplanet.net/downloads/WDPA_'+str(now.strftime('%B'))+str(nrow.year)+'?type=shapefile'

### Preliminary processing
# load parameters
with open("general.toml") as conffile:
	general_params = toml.loads(conffile.read())

### Main processing
# download file
filename = wget.download(url, out='data/raw/WDPA-shapefile.zip')

# unzip file
ZipFile(filename).extractall('data/raw/WDPA-shapefile.zip')
