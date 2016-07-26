REM check that pip is installed and install it if needed
@pip -v
if errorlevel 1 goto failed
:failed
	echo "installing pip"
	@python https://bootstrap.pypa.io/get-pip.py
	@setx PATH "%PATH%;C:/Python27/Scripts"

REM check that python packages are installed and install them if needed
@python -c 'import toml'
if errorlevel 1 goto failed
:failed
	echo "installing toml package"
	@pip install toml

@python -c 'import wget'
if errorlevel 1 goto failed
:failed
	echo "installing wget package"
	@pip install wget

REM run data processing
make clean all
