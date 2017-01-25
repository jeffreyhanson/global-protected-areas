# import libraries
import os, sys

# define functions
def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)
		
# create file
touch(sys.argv[1])
