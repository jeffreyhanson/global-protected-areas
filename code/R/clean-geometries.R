### Initialization
# set parameters
args <- commandArgs(trailingOnly=TRUE)

# load packages
library(rgrass7)

### Preliminary processing
# set grass workspace
initGRASS(dir('C:/Program Files', 'GRASS', full=TRUE), home=tempdir())

### Main processing
# import data into GRASS and fix issues
execGRASS('v.in.ogr', flags='o', input=args[1], output='map')

# export data from GRASS
execGRASS('v.out.ogr', flags=c('c', 'e', 'm', 'overwrite'), input='map', type='area', output=args[1])



