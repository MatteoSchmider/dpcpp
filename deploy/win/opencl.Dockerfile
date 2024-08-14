FROM mcr.microsoft.com/windows/servercore:ltsc2022

# copy compiled dpcpp compiler
COPY "dpcpp" "C:\dpcpp"

# add it to the path for direct use
RUN setx /M PATH "%PATH%;C:\dpcpp\bin"
RUN setx /M LIB "%LIB%;C:\dpcpp\lib"