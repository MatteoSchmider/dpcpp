# install build tools
choco install ninja -y
choco install cuda --version 12.6.0.560 -y

# set compiler paths
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

# download dpc++ sources into C:\dpcpp
git clone --config core.autocrlf=false https://github.com/intel/llvm -b sycl
move "llvm" "dpcpp"

# configure and compile dpc++
python "dpcpp\buildbot\configure.py" --cuda -t Release --cmake-opt "-DCUDA_CUDART_LIBRARY=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.6\lib\x64\cudart.lib"
python "dpcpp\buildbot\compile.py" -j 16