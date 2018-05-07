set ARGS=-DCMAKE_TOOLCHAIN_FILE=%~dp0\..\build_vcpkg\scripts\buildsystems\vcpkg.cmake -DHDF5_BUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_CPP_LIB:BOOL=OFF -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DHDF5_ENABLE_THREADSAFE:BOOL=ON -DCMAKE_CONFIGURATION_TYPES=RelWithDebInfo ..

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


mkdir bin32
copy build_win32\bin\RelWithDebInfo\hdf5.dll build_win32\bin\RelWithDebInfo\hdf5_hl.dll build_win32\bin\RelWithDebInfo\zlib1.dll bin32\
mkdir bin64
copy build_win64\bin\RelWithDebInfo\hdf5.dll build_win64\bin\RelWithDebInfo\hdf5_hl.dll build_win64\bin\RelWithDebInfo\zlib1.dll bin64\
7z a hdf5_windows.zip bin32\*.dll bin64\*.dll
