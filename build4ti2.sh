#! /bin/bash

set -x


echo "building libGMP"
wget --progress=dot:mega https://gmplib.org/download/gmp/gmp-6.2.1.tar.bz2 ; 
tar xjf gmp-6.2.1.tar.bz2 ; 
cd gmp-6.2.1 ; 
./configure --enable-cxx --enable-fat --prefix=$(pwd)/../usr/local  --build=westmere-pc-linux-gnu --disable-shared
make -j 
make install 
cd ..     

echo "building glpk"
wget --progress=dot:mega http://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz
tar xvzf glpk-5.0.tar.gz 
cd glpk-5.0/
./configure CFLAGS="-I$PWD/../usr/local/include" LDFLAGS="-L$PWD/../usr/local/lib" --prefix=$PWD/../usr/local/
make -j
make install
cd ..

echo "Building 4ti2"
wget --progress=dot:mega https://github.com/4ti2/4ti2/releases/download/Release_1_6_9/4ti2-1.6.9.tar.gz
tar xvzf 4ti2-1.6.9.tar.gz
cd 4ti2-1.6.9/
autoreconf -vfi
echo "4ti2int64_LDFLAGS=-all-static -static-libgcc -static-libstdc++ \$(LDFLAGS)" >> src/groebner/Makefile.am ;  
./configure CFLAGS="-I$PWD/../usr/local/include" CXXFLAGS="-I$PWD/../usr/local/include" LDFLAGS="-L$PWD/../usr/local/lib" --prefix=$PWD/../usr/local/
make -j
rm src/groebner/4ti2int64
make
mkdir -p ../website
cp src/groebner/4ti2int64 ../website/qsolve
strip -s ../website/qsolve
cd ..


echo "Done"
echo ""

