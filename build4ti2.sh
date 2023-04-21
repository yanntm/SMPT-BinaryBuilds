#! /bin/bash




echo "Installing latte-distro"
wget --progress=dot:mega -O latte-distro-version_1_7_5.zip https://github.com/latte-int/latte-distro/archive/refs/tags/version_1_7_5.zip
unzip latte-distro-version_1_7_5.zip
rm latte-distro-version_1_7_5.zip
cd latte-distro-version_1_7_5
autoreconf -vfi
./configure
make -j

echo "Extracting 4ti2"
cd 4ti2-1.6.9
echo "4ti2int64_LDFLAGS=-all-static -static-libgcc -static-libstdc++ $(LDFLAGS) " >> src/groebner/Makefile.am ;  
autoreconf -vfi ;
./configure LDFLAGS=-L/$PWD/../dest/lib/ --without-zsolve --with-gmp=no ; 
make -j
rm src/groebner/4ti2int64
make

mkdir -p ../../website
cp src/groebner/4ti2int64 ../../website/qsolve
strip -s ../../website/qsolve

cd ../../

echo "Done"
echo ""

