FROM mcr.microsoft.com/windows/servercore:ltsc2022

# install chocolatey
RUN powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
RUN setx /M PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# install cuda
RUN choco install cuda -y

# copy compiled dpcpp compiler
COPY "dpcpp" "C:\dpcpp"

# add it to the path for direct use
RUN setx /M PATH "%PATH%;C:\dpcpp\bin"
RUN setx /M LIB "%LIB%;C:\dpcpp\lib"