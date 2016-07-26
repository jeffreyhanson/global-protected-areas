Global protected areas (under active development)
=================================================
[![DOI](https://zenodo.org/badge/18940/paleo13/global-protected-areas.svg)](https://zenodo.org/badge/latestdoi/18940/paleo13/global-protected-areas)

[Jeffrey O. Hanson](wwww.jeffrey-hanson.com)

Correspondence should be addressed to [jeffrey.hanson@uqconnect.edu.au](mailto:jeffrey.hanson@uqconnect.edu.au)

-----

This repository contains source code for automatically downloading, cleaning, and processing the [World Database on Protected Areas](www.protectedplanet). By using this repository, users can maintain an update version of the world's protected areas data set.

Briefly, the following operations are run in sequence using [ESRI ArcGIS](www.esri.com/software/arcgis) :
1. raw data is downloaded
2. geometry issues are resolved
3. invalid protected areas are omitted
4. protected areas are simplified to reduce computation burden
5. protected areas only represented as points are buffered and merged with polygons
6. protected areas are dissolved such that overlapping areas are assigned the best IUCN criteria
7. protected areas are converted to raster format

To run all computational analyses: run `make clean && make all` in the command prompt. After the processing has completed the final shapefile will be stored in "data/final". *Note that all parameters can be customized by altering files in the parameters folder.* 

-----

### Repository overview

* data
	+ _raw_: raw data downloaded form [protected planet](www.protectedplanet.net)
	+ _intermediate_: data generated during processing
	+ _final_: final cleaned dataset
* code
	+ _parameters_: files used to customise analysis in [TOML format](https://github.com/toml-lang/toml)
	+ [_python_](www.python.org): scripts used to run the analysis 

### Software

* Operating system
	+ Windows (7+)
* Programs
	+ ArcGIS (version 10.1)
	+ GNU make
 
**If you found this repository helped you, please cite it.**

Hanson J.O. (2016). Global protected areas. version 0.0.0. doi: XXXXX.
