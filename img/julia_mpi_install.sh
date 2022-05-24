#!/usr/bin/env bash

dnf update -y
dnf clean all -y

dnf groupinstall "Development Tools" -y

dnf install gcc-gfortran environment-modules libatomic -y

cd /opt
git clone -c feature.manyFiles=true https://github.com/spack/spack.git
ln -s /opt/spack/bin/spack /usr/local/bin/spack
export PATH=$PATH:/usr/local/bin

spack mirror add E4S https://cache.e4s.io
spack buildcache keys -it

spack compiler find

spack install openmpi
spack install julia

. /opt/spack/share/spack/setup-env.sh

spack load openmpi
spack load julia

cd ~

mkdir -p /usr/local/share/applications/julia/depot
export JULIA_DEPOT_PATH=/usr/local/share/applications/julia/depot:$JULIA_DEPOT_PATH

julia -e 'ENV["JULIA_MPI_BINARY"]="system"; using Pkg; Pkg.add("MPI"); Pkg.add("ImplicitGlobalGrid"); Pkg.add("Plots")'

chmod a+rw -R /usr/local/share/applications/julia/depot
