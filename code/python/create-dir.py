### Initialization
# load libraries
import os
import sys

### Main processing
# create directory if it doesn't exist
if not os.path.exists(sys.argv[1]):
    os.makedirs(sys.argv[1])
