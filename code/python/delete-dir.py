### Initialization
# load libraries
import os, sys, shutil

# store cmd arguments
input_PTH = sys.argv[1]

### Main processing
if os.path.exists(input_PTH):
	shutil.rmtree(input_PTH)
