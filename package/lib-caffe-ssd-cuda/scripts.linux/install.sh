#! /bin/bash

#
# Installation script for Caffe.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2015;
# - Anton Lokhmotov, 2016.
#

# PACKAGE_DIR
# INSTALL_DIR

echo "**************************************************************"
echo "Preparing vars for Caffe ..."

CK_OPENMP="-fopenmp"
if [ "${CK_HAS_OPENMP}" = "0"  ]; then
  CK_OPENMP=""
fi

# Check extra stuff
EXTRA_FLAGS=""

XCMAKE_AR=""
if [ "${CK_AR_PATH_FOR_CMAKE}" != "" ] ; then
    XCMAKE_AR=" -DCMAKE_AR=${CK_AR_PATH_FOR_CMAKE} "
fi

XCMAKE_LD=""
if [ "${CK_LD_PATH_FOR_CMAKE}" != "" ] ; then
    XCMAKE_LD=" -DCMAKE_LINKER=${CK_LD_PATH_FOR_CMAKE} "
fi

# For a non-standard CUDA installation path, CUDA_BIN_PATH must be set BEFORE
# running CMake (see https://cmake.org/cmake/help/v3.5/module/FindCUDA.html).
export CUDA_BIN_PATH=${CK_ENV_COMPILER_CUDA}

cd ${INSTALL_DIR}/obj

cmake -DCMAKE_BUILD_TYPE=${CK_ENV_CMAKE_BUILD_TYPE:-Release} \
      -DCMAKE_C_COMPILER="${CK_CC_PATH_FOR_CMAKE}" \
      -DCMAKE_C_FLAGS="${CK_CC_FLAGS_FOR_CMAKE} ${EXTRA_FLAGS}" \
      -DCMAKE_CXX_COMPILER="${CK_CXX_PATH_FOR_CMAKE}" \
      -DCMAKE_CXX_FLAGS="${CK_CXX_FLAGS_FOR_CMAKE} ${EXTRA_FLAGS} -I${CK_ENV_LIB_OPENCV_INCLUDE}" \
      ${XCMAKE_AR} \
      ${XCMAKE_LD} \
      -DCMAKE_SHARED_LINKER_FLAGS="$CK_OPENMP" \
      -DBUILD_python=ON \
      -DPYTHON_EXECUTABLE:FILEPATH="$CK_ENV_COMPILER_PYTHON_FILE" \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=$CPU_ONLY \
      -DUSE_OPENMP=OFF \
      -DUSE_GREENTEA=OFF \
      -DUSE_LMDB=ON \
      -DUSE_LEVELDB=ON \
      -DUSE_HDF5=ON \
      -DBLAS=open \
      -DGFLAGS_INCLUDE_DIR="${CK_ENV_LIB_GFLAGS_INCLUDE}" \
      -DGLOG_INCLUDE_DIR="${CK_ENV_LIB_GLOG_INCLUDE}" \
      -DBoost_ADDITIONAL_VERSIONS="1.62" \
      -DBOOST_ROOT=${CK_ENV_LIB_BOOST} \
      -DBOOST_INCLUDEDIR="${CK_ENV_LIB_BOOST_INCLUDE}" \
      -DBOOST_LIBRARYDIR="${CK_ENV_LIB_BOOST_LIB}" \
      -DBoost_INCLUDE_DIR="${CK_ENV_LIB_BOOST_INCLUDE}" \
      -DBoost_LIBRARY_DIR="${CK_ENV_LIB_BOOST_LIB}" \
      -DHDF5_DIR="${CK_ENV_LIB_HDF5}/cmake" \
      -DHDF5_ROOT_DIR="${CK_ENV_LIB_HDF5}/cmake" \
      -DHDF5_INCLUDE_DIRS="${CK_ENV_LIB_HDF5_INCLUDE}" \
      -DOpenBLAS_INCLUDE_DIR="${CK_ENV_LIB_OPENBLAS_INCLUDE}" \
      -DOpenBLAS_LIB="${CK_ENV_LIB_OPENBLAS_LIB}/libopenblas.a" \
      -DLMDB_INCLUDE_DIR="${CK_ENV_LIB_LMDB_INCLUDE}" \
      -DOpenCV_DIR="${CK_ENV_LIB_OPENCV_JNI}" \
      -DPROTOBUF_INCLUDE_DIR="${CK_ENV_LIB_PROTOBUF_HOST_INCLUDE}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${CK_ENV_LIB_PROTOBUF_HOST}/bin/protoc" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/install" \
      -DCMAKE_VERBOSE_MAKEFILE=ON \
      -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF \
      -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
      ${PACKAGE_CONFIGURE_FLAGS} \
      ${INSTALL_DIR}/${PACKAGE_SUB_DIR}

if [ "${?}" != "0" ] ; then
  echo "Error: cmake failed!"
  exit 1
fi

return 0
