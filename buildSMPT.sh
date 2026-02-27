#! /bin/bash


pip3 install cx_freeze mypy sexpdata

git clone https://github.com/nicolasAmat/SMPT.git

cd SMPT

\cp ../setup.py .

python3 setup.py build

cd build/*/
tar cvzf smpt.tgz *

cp smpt.tgz ../../../website/

cd ../../..

