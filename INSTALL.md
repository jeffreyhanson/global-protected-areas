Installation Instructions
==========================

This program has several dependencies that need to be installed before it can be used.

The following programs need to be installed to use this program. Follow the instructions underneath them to install them.

* ArcMap 
	+ contact your IT support
* GNU make
	+ in my opinion, the easiest way to install GNU make is to [install Rtools](https://cran.r-project.org/bin/windows/Rtools/index.html)
	+ if you prefer to use the official MINGW version, [please see this video for instructions](https://www.youtube.com/watch?v=1N-g-Xvw3CM)
	+ ensure that the PATH variable is set to refer to the bin directory
* pip
	+ [download and run this python script](https://bootstrap.pypa.io/get-pip.py)
	+ add the `Scripts` folder in the ArcGIS folder to the PATH variable (eg. C:\Python27\ArcGIS10.3\Scripts)

The following python packages are also required to use this program:

* wget
	+ run the following code in the command prompt: `pip install wget`
* toml 
	+ run the following code in the command prompt: `pip install toml`

