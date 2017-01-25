### Initialization
# load libraries
import os, sys, glob

### Main processing
for f in glob.glob(sys.argv[1]):
	os.remove(f)
