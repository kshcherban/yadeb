# yadeb
### Description

This is docker image to build debian source packages in clean container environment.

You can set following variables:  
- `DEBEMAIL`, default is `test@example.com`
- `DEBFULLNAME`, default is `John Doe`
- `DEBCHANGE_TZ`, default is `Europe/Berlin`
- `QUILT_PATCHES`, default is `debian/patches`
- `QUILT_REFRESH_ARGS`, default is `-p ab --no-timestamps --no-index`

Please check https://www.debian.org/doc/manuals/maint-guide/first.en.html#dh-make
and https://wiki.debian.org/UsingQuilt for reference.

Container creates volume `/opt/buildroot`. It's supposed to be used for package building.

Current dockerfile is based on `debian:jessie` but you can change it to any
Debian or Ubuntu distribution and it should work.

### Usage

Build image.

```
git clone https://github.com/kshcherban/yadeb
cd yadeb
docker build -t yadeb .
```

For the sake of example let's build [yandex-tank](https://github.com/yandex/yandex-tank) debian package.

Download or prepare unpacked [debian source package](https://wiki.debian.org/BuildingTutorial) in some directory:
```
git clone --depth=1 https://github.com/yandex/yandex-tank /tmp/yatank/yandex-tank
docker run --rm -ti -v /tmp/yatank:/opt/buildroot yadeb build.sh
```

You should find debian source and binary in `/tmp/yatank`.
```
ls -la /tmp/yatank
total 1328
drwxrwxr-x  3 insider insider    4096 Dec 26 15:02 .
drwxrwxrwt 21 root    root      12288 Dec 26 15:02 ..
drwxrwxr-x 11 insider insider    4096 Dec 26 15:02 yandex-tank
-rw-r--r--  1 root    root     101246 Dec 26 15:02 yandex-tank_1.7.31_all.deb
-rw-r--r--  1 root    root       1244 Dec 26 15:02 yandextank_1.7.31_amd64.changes
-rw-r--r--  1 root    root        609 Dec 26 15:01 yandextank_1.7.31.dsc
-rw-r--r--  1 root    root    1227677 Dec 26 15:01 yandextank_1.7.31.tar.gz
```

Please pay attention that you should mount unpacked source package **parent** directory into container.


Alternatively you can run bash inside container and build package manually.
```
docker run --rm -ti -v /tmp/yatank:/opt/buildroot yadeb bash
cd /opt/buildroot/yandex-tank
dpkg-buildpackage -F
```
