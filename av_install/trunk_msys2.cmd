@SETLOCAL

@set ORIG_PATH_1=%PATH%
@PATH=C:\msys64\usr\bin;C:\ruby24-x64\bin;C:\Program Files\7-Zip;C:\Program Files\AppVeyor\BuildAgent;C:\Program Files\Git\cmd;C:\Windows\system32;C:\Program Files;C:\Windows

@echo --------------------------------------------------------------- Updating MSYS2 / MinGW
@pacman -Sy --noconfirm --needed mingw-w64-x86_64-toolchain mingw-w64-x86_64-gcc-libs mingw-w64-x86_64-gmp mingw-w64-x86_64-libffi mingw-w64-x86_64-zlib

@set    gdbm=mingw-w64-x86_64-gdbm-1.10-2-any.pkg.tar.xz
@set openssl=mingw-w64-x86_64-openssl-1.1.0.f-1-any.pkg.tar.xz

@echo --------------------------------------------------------------- Adding GPG key
@bash -lc "pacman-key -r 77D8FA18 --keyserver na.pool.sks-keyservers.net && pacman-key -f 77D8FA18 && pacman-key --lsign-key 77D8FA18"

@md C:\pkgs

@echo --------------------------------------------------------------- Replacing gdbm with gdbm-1.10
appveyor DownloadFile https://dl.bintray.com/msp-greg/ruby_windows/%gdbm%     -FileName C:\pkgs\%gdbm%
appveyor DownloadFile https://dl.bintray.com/msp-greg/ruby_windows/%gdbm%.sig -FileName C:\pkgs\%gdbm%.sig
@pacman -Rdd --noconfirm mingw-w64-x86_64-gdbm > nul
@pacman -Udd --noconfirm --force  /c/pkgs/%gdbm%    > nul

@echo --------------------------------------------------------------- Replacing openssl with openssl-1.1.0
appveyor DownloadFile https://dl.bintray.com/msp-greg/ruby_windows/%openssl%     -FileName C:\pkgs\%openssl%
appveyor DownloadFile https://dl.bintray.com/msp-greg/ruby_windows/%openssl%.sig -FileName C:\pkgs\%openssl%.sig
@pacman -Rdd --noconfirm mingw-w64-x86_64-openssl > nul
@pacman -Udd --noconfirm --force /c/pkgs/%openssl%     > nul

@echo --------------------------------------------------------------- MinGW Package Check
@bash -lc "pacman -Qs x86_64\.\+\(gcc\|gdbm\|openssl\) | sed -n '/^local/p' | sed 's/^local\///' | sed 's/ (.\+$//'"

@PATH=%ORIG_PATH_1%
@ENDLOCAL
