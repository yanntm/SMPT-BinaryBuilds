#!/bin/bash
set -x

mkdir -p usr/local/
export IDIR=$PWD/usr/local/

# required for these old tools.
export CC="gcc -std=gnu17"

echo "building libGMP"
wget --progress=dot:mega https://gmplib.org/download/gmp/gmp-6.2.1.tar.bz2
tar xjf gmp-6.2.1.tar.bz2
cd gmp-6.2.1
./configure --enable-cxx --enable-fat --disable-shared --prefix="$IDIR" 
# --build=westmere-pc-linux-gnu : required in MCC, but obsolete.
make -j
make install          # no sudo needed any more
cd ..

echo "building glpk"
wget --progress=dot:mega http://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz
tar xzf glpk-5.0.tar.gz
cd glpk-5.0/
./configure --prefix="$IDIR" CFLAGS="-I$IDIR/include" LDFLAGS="-L$IDIR/lib"
make -j
make install          # no sudo needed any more
cd ..

echo "Building 4ti2"
wget --progress=dot:mega https://github.com/4ti2/4ti2/releases/download/Release_1_6_14/4ti2-1.6.14.tar.gz
tar xzf 4ti2-1.6.14.tar.gz
cd 4ti2-1.6.14/

autoreconf -vfi

# for i in $(find -name Makefile.am -print) ; do sed -i 's/AM_CXXFLAGS =/AM_CXXFLAGS = $(CXXFLAGS)/g' $i ; done

echo "4ti2int64_LDFLAGS=-all-static -static-libgcc -static-libstdc++ \$(LDFLAGS)" >> src/groebner/Makefile.am ;
echo "zsolve_LDFLAGS=-all-static -static-libgcc -static-libstdc++ \$(LDFLAGS)" >> src/zsolve/Makefile.am ;
./configure CFLAGS="-I$IDIR/include" CXXFLAGS="-I$IDIR/include" LDFLAGS="-I$IDIR/include -L$IDIR/lib" --prefix=$IDIR
make -j
rm src/groebner/4ti2int64
rm src/zsolve/zsolve
make

mkdir -p ../website
cp src/groebner/4ti2int64 ../website/
cp src/groebner/qsolve ../website/
cp src/groebner/zbasis ../website/
cp src/zsolve/zsolve ../website/
cp src/zsolve/hilbert ../website/

strip -s ../website/4ti2int64
strip -s ../website/zsolve
cd ..

if [ ! -f website/qsolve ] ; then cat 4ti2-1.6.14/config.log ; fi

echo "Done"
echo ""