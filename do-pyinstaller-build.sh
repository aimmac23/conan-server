#!/bin/bash

set -e

git clone https://github.com/conan-io/conan.git
cd conan
git checkout 2.23.0

python3 -m venv venv
. venv/bin/activate

pip install -r conans/requirements.txt
pip install -r conans/requirements_server.txt
pip install pyinstaller

python setup_server.py install

python -m PyInstaller --copy-metadata conan_server --hidden-import=conans --hidden-import=conans.conan_server venv/bin/conan_server 

