# pi-flashrom
Tool used to create a Raspbian-lite image ready to be used with [Flashrom](https://www.flashrom.org/Flashrom) and [Coreboot](https://www.coreboot.org/)

### What is different?
* No stage 3 or stage 4.  Raspbian lite only.
* SSH server enabled by default
* Linux SPI enabled by default
* Flashrom and dependencies for building Coreboot preinstalled
* `config` added
* Simplified Wifi configuration (see below)
* Command alias (see below)

## Build.sh Dependencies

`quilt parted realpath qemu-user-static debootstrap zerofree pxz zip dosfstools bsdtar libcap2-bin grep rsync`

## Config

Upon execution, `build.sh` will source the file `config` in the current
working directory.  This bash shell fragment is intended to set needed
environment variables.

The following environment variables are supported:

 * `IMG_NAME` **required** (Default: 'Raspbian-flashrom')

   The name of the image to build with the current stage directories.  Export files
   in stages may add suffixes to `IMG_NAME`.

 * `APT_PROXY` (Default: unset)

   If you require the use of an apt proxy, set it here.  This proxy setting
   will not be included in the image, making it safe to use an `apt-cacher` or
   similar package for development.

## Docker Build

```bash
./build-docker.sh
```
If everything goes well, your finished image will be in the `deploy/` folder.
You can then remove the build container with `docker rm pigen_work`

If something breaks along the line, you can edit the corresponding scripts, and
continue:

```
CONTINUE=1 ./build-docker.sh
```

There is a possibility that even when running from a docker container, the installation of `qemu-user-static` will silently fail when building the image because `binfmt-support` _must be enabled on the underlying kernel_. An easy fix is to ensure `binfmt-support` is installed on the host machine before starting the `./build-docker.sh` script (or using your own docker build solution).

### Raspbian Stage Overview
Refer to [RPi-Distro/pi-gen]( https://github.com/RPi-Distro/pi-gen)

### Connecting the flash chip
[ Flashrom RaspberryPi](https://www.flashrom.org/RaspberryPi#Connecting_the_flash_chip)

### Enable wifi
**Step 1** - Uncomment the following lines in `/etc/network/interfaces`
```bash
#auto wlan0
#allow-hotplug wlan0
#iface wlan0 inet manual
#    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

**Step 2** - Uncomment and modify the following lines in `/etc/wpa_supplicant/wpa_supplicant.conf`
```bash
#network={
#    ssid="Your_ESSID"
#    psk="Your_wifi_password"
#}
```

**NOTE**: If modifying before building the image, the files are located `stage1/02-net-tweaks/files/interfaces` and `stage2/02-net-tweaks/files/wpa_supplicant.conf` respectively.

### Aliases
`~/.bash_aliases`
* `flashrom-read`  
 * alias of:  
 ```
 sudo /usr/local/sbin/flashrom -p linux_spi:dev=/dev/spidev0.0
 ```
 * append additional arguments as needed

**NOTE**: If modifying before building the image, the file is located `stage2/03-flashrom/files/bash_aliases`.
