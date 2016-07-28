REM installation checks
@ECHO OFF
REM check that pip is installed
pip -v || echo. & echo pip is not installed. Please see INSTALL.md & pause & exit

REM check that python packages are installed
python -c 'import toml' || echo. & echo python package 'toml' is not installed. Please see INSTALL.md & pause & exit
python -c 'import wget' ||  echo. & echo python package 'wget' is not installed. Please see INSTALL.md & pause & exit

REM check that R is installed
R -v || echo. & echo R is not installed. Please see INSTALL.md & pause & exit

REM check that R packages are installed
R -e "library('rgrass7')" || echo. & echo R package 'rgrass7' is not installed. Please see INSTALL.md & pause & exit
ECHO

make clean all || pause & exit
