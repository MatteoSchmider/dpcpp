:: install ninja
choco install ninja -y

:: set compiler paths
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

:: download dpc++ sources into C:\dpcpp
git clone --config core.autocrlf=false https://github.com/intel/llvm -b sycl
move "llvm" "dpcpp"

:: configure and compile dpc++
python "dpcpp\buildbot\configure.py" -t Release
python "dpcpp\buildbot\compile.py" -j 16