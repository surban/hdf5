set ARGS=-DCMAKE_TOOLCHAIN_FILE=%~dp0\..\build_vcpkg\scripts\buildsystems\vcpkg.cmake -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DCMAKE_CONFIGURATION_TYPES=RelWithDebInfo ..

for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
  set InstallDir=%%i
)

cd %~dp0\..
git clone https://github.com/Microsoft/vcpkg build_vcpkg
cd build_vcpkg
call bootstrap-vcpkg.bat
vcpkg.exe install zlib:x86-windows
vcpkg.exe install zlib:x64-windows
cd ..

mkdir build_win64
cd build_win64
cmake -G "Visual Studio 15 2017 Win64" %ARGS%
"%InstallDir%\MSBuild\15.0\Bin\MSBuild.exe" /m HDF5.sln  
cd ..

mkdir build_win32
cd build_win32
cmake -G "Visual Studio 15 2017" %ARGS%
"%InstallDir%\MSBuild\15.0\Bin\MSBuild.exe" /m HDF5.sln  
cd ..

