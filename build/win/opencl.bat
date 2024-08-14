:: install ninja
choco install ninja -y

:: set compiler paths
dir 
dir "C:\Program Files"
dir "C:\Program Files\Microsoft Visual Studio\2022\Enterprise
call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

:: download dpc++ sources into C:\dpcpp
git clone --config core.autocrlf=false https://github.com/intel/llvm -b sycl
move "llvm" "dpcpp"

:: configure and compile dpc++
python "dpcpp\buildbot\configure.py" -t Release
python "dpcpp\buildbot\compile.py" -j 16