### Initialization
# load libraries
import arcpy
import sys
import os

# set environmental variables
arcpy.env.overwriteOutput = True

### Main processing
# create gdb
arcpy.CreateFileGDB_management(os.path.dirname(sys.argv[1]), os.path.basename(sys.argv[1]))
