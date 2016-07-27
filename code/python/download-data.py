### Initialization
# load libraries
import toml
import wget
import datetime
import os
import zipfile

# define parameters
now=datetime.datetime.now()
url='http://www.protectedplanet.net/downloads/WDPA_'+str(now.strftime('%B'))+str(now.year)+'?type=shapefile'

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

### Main processing
# download file
filename = wget.download(url, out='data/raw/WDPA-shapefile.zip')

# unzip file
os.mkdir('data/raw/WDPA-shapefile')
zip=zipfile.ZipFile(filename)
zip.extractall('data/raw/WDPA-shapefile')
