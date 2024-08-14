FROM mcr.microsoft.com/windows/servercore:ltsc2022

# install chocolatey
RUN powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
RUN setx /M PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# install build tools
RUN choco install visualstudio2022buildtools -y --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.ATL --includeRecommended"
RUN choco install git -y
RUN choco install cmake -y
RUN choco install ninja -y
RUN choco install python -y
RUN choco install curl -y
RUN choco install 7zip -y

# set build env script variable
RUN setx BUILD_ENV "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

# download dpc++ sources
RUN curl -L -o "llvm.zip" https://github.com/intel/llvm/archive/refs/tags/2024-WW25.zip
RUN 7z x "llvm.zip" && move "llvm-2024-WW25" "llvm" && del "llvm.zip"

# configure and compile dpc++
RUN call "%BUILD_ENV%" && python "C:\llvm\buildbot\configure.py" -t Release
RUN call "%BUILD_ENV%" && python "C:\llvm\buildbot\compile.py" -j 16