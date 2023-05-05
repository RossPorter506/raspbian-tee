# Instructions to load RaspbianTEE on RPi3
##### from https://github.com/benhaz1024/raspbian-tee
#
---
### Prerequisites
- Raspbian 32bit image (newer versions don't work, 2018-03-13-raspbian-stretch image works)
  -- Link to download the image:
    https://downloads.raspberrypi.org/raspbian/images/raspbian-2018-03-14/2018-03-13-raspbian-stretch.zip
- Trusted Firmware-A now only have 64-bit support for Raspberry Pi 3
---
### Dependencies
1. Host OS: Ubuntu 16.04 or later (tested with Ubuntu 22.04, ok, but with a problem with gcc, explained below)
2. Cross Build Toolchain: AARCH64 & AARCH32 both needed, and AARCH32 must > 6.0 (from Linaro)
   -- 32 bit Cross Build Toolchain: 
    https://publishing-ie-linaro-org.s3.amazonaws.com/releases/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
   -- 64 bit Cross Build Toolchain: 
    https://publishing-ie-linaro-org.s3.amazonaws.com/releases/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
3. Hardware: Raspberry Pi 3B or 3B+ only
---
### Build
Clone the repository from https://github.com/benhaz1024/raspbian-tee\
`	$ clone https://github.com/benhaz1024/raspbian-tee\`
	
Change config.mk file first to point to the cross build toolchains (extracted first), example below:
`export CROSS_COMPILE := /home/kostas00t/RaspbianTEE/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-`
`export CROSS_COMPILE_AARCH64 := /home/kostas00t/RaspbianTEE/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-`

Run the following commands from raspbian-tee folder to build

`	$ .prepare-env.sh 	# skip if your had downloaded all packages`
`	$ make patch 		# this will patch linux kernel & TF-A, if you have done before, skip this.`
`	$ make`
	
When success, it should seem as:
![](https://github.com/benhaz1024/raspbian-tee/blob/master/doc/raspbian-tee-output.jpg)


##### Problems occured while running the building commands
- A python script failed, used the command below to solve it 
`$ pip install pycryptodome`
	
- Ubuntu 22.04 used gcc-11 and caused problems in compilation, installing and setting as default the gcc-9 solved the issue
`$ sudo apt install gcc-9`
`$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9`
	
- Problem during make phase with yylloc, change the (-) line with (+) line at files, 
`      /raspbian-tee/u-boot/scripts/dtc/dtc-lexel.lex.c 	(at line 618)`
`      /raspbian-tee/linux/scripts/dtc/dtc-lexel.lex.c 	(at line 634) `
	
    (-) `YYLTYPE yylloc;`
    (+) `extern YYLTYPE yylloc;`
	
- Final stages of compilation required the following tool to be installed
`$ sudo apt install u-boot-tools`

---
### Installation

After successful compilation, flash the raspbian image from before to a microSD card (I used the official imager from RPi, installed with $ sudo apt install rpi-imager)

Mount the partitions at /media/*<yourusername>*/boot & /media/*<yourusername>*/rootfs (change every *<yourusername>*, with your username)
`	$ sudo mkdir /media/<yourusername>/boot `
`	$ sudo mkdir /media/<yourusername>/rootfs `
`	$ sudo mount /dev/sda1 /media/<yourusername>/boot    # Change sda1 to the appropriate microSD boot partition `
`	$ sudo mount /dev/sda2 /media/<yourusername>/rootfs  # Change sda2 to the appropriate microSD rootfs partition `
	
Run the following commands from raspbian-tee folder to copy 
`	$ sudo cp ./out/boot/* /media/<yourusername>/boot		# copies all files from ./out/boot to the boot partition of the microSD card`
`	$ sudo cp -r ./out/rootfs/* /media/<yourusername>/rootfs	# copies all files and folders from ./out/rootfs to the rootfs partition of the microSD card`

Unmount the microSD card to avoid file system corruption 
`	$ sudo umount /dev/sda1 			     # Change sda1 to the appropriate microSD partition `
`	$ sudo umount /dev/sda2 			     # Change sda2 to the appropriate microSD partition `

---
### Boot up the RPi3 using the microSD with the modified image

From the HDMI output we can see the regular Raspbian REE
From the UART output we can see the terminal for the OP-TEE OS 
-- (run from building pc after connecting the RPi3 through the UART interface:  $ sudo picocom -b 115200 /dev/ttyUSB0)
After logging in, run the following commands from REE to test that everything works as intended.

`	$ ls /dev/tee*`
`	/dev/tee0 /dev/teepriv0 	# this prove tee driver & optee-os works.`
`	$ sudo tee-supplicant &`
`	$ sudo optee_example_hello_world`

-- (There should be no errors, if everything runs as intended)


