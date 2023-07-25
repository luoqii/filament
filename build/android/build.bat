setlocal

if "%GITHUB_WORKFLOW%" == "" (set RUNNING_LOCALLY=1)

if "%RUNNING_LOCALLY%" == "1" (
    set GENERATOR="Visual Studio 16 2019"
) else {
    set GENERATOR="ninja"
}

rem https://github.com/google/filament/blob/main/android/Windows.md
mkdir out\cmake-release
cd out\cmake-release
cmake ^
    -G %GENERATOR% ^
    -DCMAKE_INSTALL_PREFIX=..\release\filament ^
    -DFILAMENT_ENABLE_JAVA=NO ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..\..
ninja matc resgen cmgen
ninja install
cd ..\..

mkdir out\cmake-android-release-aarch64
cd out\cmake-android-release-aarch64
cmake ^
    -G %GENERATOR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=..\android-release\filament ^
    -DCMAKE_TOOLCHAIN_FILE=..\..\build\toolchain-aarch64-linux-android.cmake ^
    ..\..
ninja install
cd ..\..

mkdir out\cmake-android-release-arm7
cd out\cmake-android-release-arm7
cmake ^
    -G %GENERATOR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=..\android-release\filament ^
    -DCMAKE_TOOLCHAIN_FILE=..\..\build\toolchain-arm7-linux-android.cmake ^
    ..\..
ninja install
cd ..\..

mkdir out\cmake-android-release-x86_64
cd out\cmake-android-release-x86_64
cmake ^
    -G %GENERATOR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=..\android-release\filament ^
    -DCMAKE_TOOLCHAIN_FILE=..\..\build\toolchain-x86_64-linux-android.cmake ^
    ..\..
ninja install
cd ..\..

mkdir out\cmake-android-release-x86
cd out\cmake-android-release-x86
cmake ^
    -G %GENERATOR% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=..\android-release\filament ^
    -DCMAKE_TOOLCHAIN_FILE=..\..\build\toolchain-x86-linux-android.cmake ^
    ..\..
ninja install
cd ..\..

cd android
gradlew -Pcom.google.android.filament.dist-dir=..\out\android-release\filament assembleRelease
copy filament-android\build\outputs\aar\filament-android-release.aar ..\..\out\
