Installation Instructions
==========================

This program has several dependencies that need to be installed before it can be used.

The following programs need to be installed to use this program. Follow the instructions underneath them to install them.

* ArcMap 
	+ contact your IT support
* GNU make
	+ install MINGW following (instructions in this video)[https://www.youtube.com/watch?v=1N-g-Xvw3CM]
	+ ensure that the PATH variable is set to refer to the bin directory
* pip
	+ (download and run this python script)[https://bootstrap.pypa.io/get-pip.py]
	+ add the `Scripts` folder in the ArcGIS folder to the PATH variable (eg. C:\Python27\ArcGIS10.3\Scripts)
* grass
	+ (download the installer and follow the instructions)[https://grass.osgeo.org/download/software/ms-windows/]
	+ add the `OSGeo4W64/bin` to the PATH variable (eg. C:\OSGeo4W64\bin)
* R
	+ download and install R


The following python packages are also required to use this program:

* wget
	+ run the following code in the command prompt: `pip install wget`
* toml 
	+ run the following code in the command prompt: `pip install toml`

The following R packages are also required:

* rgrass7
	+ run the following code in the command prompt: `R -e "options(repos = 'http://cran.cnr.berkeley.edu'); install.packages('rgrass7')"`
