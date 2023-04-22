#! /bin/bash

set -x

mkdir -p usr/
mkdir -p usr/local/
export IDIR=$PWD/usr/local/

echo "building libGMP"
wget --progress=dot:mega https://gmplib.org/download/gmp/gmp-6.2.1.tar.bz2 ; 
tar xjf gmp-6.2.1.tar.bz2 ; 
cd gmp-6.2.1 ; 
# --prefix=$IDIR
./configure --enable-cxx --enable-fat --build=westmere-pc-linux-gnu --disable-shared
make -j 
sudo make install 
cd ..     

echo "building glpk"
wget --progress=dot:mega http://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz
tar xzf glpk-5.0.tar.gz 
cd glpk-5.0/
./configure CFLAGS="-I$IDIR/include" LDFLAGS="-L$IDIR/lib" 
make -j
sudo make install
cd ..

ls -laR $IDIR

echo "Building 4ti2"
wget --progress=dot:mega https://github.com/4ti2/4ti2/releases/download/Release_1_6_9/4ti2-1.6.9.tar.gz
tar xzf 4ti2-1.6.9.tar.gz
cd 4ti2-1.6.9/
autoreconf -vfi

# for i in $(find -name Makefile.am -print) ; do sed -i 's/AM_CXXFLAGS =/AM_CXXFLAGS = $(CXXFLAGS)/g' $i ; done

echo "4ti2int64_LDFLAGS=-all-static -static-libgcc -static-libstdc++ \$(LDFLAGS)" >> src/groebner/Makefile.am ;  
./configure 
# CFLAGS="-I$IDIR/include" CXXFLAGS="-I$IDIR/include" LDFLAGS="-I$IDIR/include -L$IDIR/lib" --prefix=$IDIR
make -j
rm src/groebner/4ti2int64
make
mkdir -p ../website
cp src/groebner/4ti2int64 ../website/qsolve
strip -s ../website/qsolve
cd ..

if [ ! -f website/qsolve ] ; then cat 4ti2-1.6.9/config.log ; fi

echo "Done"
echo ""

