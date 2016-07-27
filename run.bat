REM installation checks
@ECHO OFF
REM check that pip is installed and install it if needed
pip -v || echo. & echo pip is not installed. Please see INSTALL.md & pause & exit

REM check that python packages are installed and install them if needed
python -c 'import toml' || echo. & echo toml package is not installed. Please see INSTALL.md & pause & exit
python -c 'import wget' ||  echo. & echo wget package is not installed. Please see INSTALL.md & pause & exit
ECHO

make clean all
