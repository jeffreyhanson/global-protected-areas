### Initialization
# load libraries
import arcpy
import toml
import wget
import datetime
import os
import zipfile

# define parameters
now=datetime.datetime.now()
url='http://wcmc.io/wdpa_current_release'

### Preliminary processing
# load parameters
with open("code/parameters/general.toml") as conffile:
	general_params = toml.loads(conffile.read())

### Main processing
# download file
current_date = str(now.strftime('%B'))+str(now.year)
filename = wget.download(url, out='data/raw/WDPA_'+current_date+'_Public.zip')

# unzip file
os.mkdir('data/raw/WDPA_geodatabase')
zip=zipfile.ZipFile(filename)
zip.extractall('data/raw/WDPA_geodatabase')
