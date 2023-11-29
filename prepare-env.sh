#!/bin/sh
[ ! -d "./dl" ] && {
	mkdir dl
}

[ ! -d "./out" ] && {
    mkdir out
    mkdir out/boot
    mkdir out/rootfs
    mkdir out/rootfs/bin
    mkdir out/rootfs/lib
    mkdir out/rootfs/lib/optee_armtz
}

[ ! -d "./toolchains" ] && {
	mkdir toolchains
}

[ -f "./dl/toolchain_aarch32.tar.xz" ] && {
	echo  "\033[32m32-bit toolchain already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading 32-bit toolchain...\n\033[0m"
	wget -O dl/toolchain_aarch32.tar.xz https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
}

[ ! -d "./toolchains/aarch32" ] && {
	echo  "\033[32mExtracting 32-bit toolchain...\n\033[0m"
	tar -xf dl/toolchain_aarch32.tar.xz && {
		mv gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf ./toolchains/aarch32
	}
}

[ -f "./dl/toolchain_aarch64.tar.xz" ] && {
	echo  "\033[32m64-bit toolchain already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading 64-bit toolchain...\n\033[0m"
	wget -O dl/toolchain_aarch64.tar.xz https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
}

[ ! -d "./toolchains/aarch64" ] && {
	echo  "\033[32mExtracting 64-bit toolchain...\n\033[0m"
	tar -xf dl/toolchain_aarch64.tar.xz && {
		mv gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu ./toolchains/aarch64
	}
}

[ -f "./dl/arm-trusted-firmware.tar.gz" ] && {
	echo  "\033[32marm-trusted-firmware already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading arm-trusted-firmware...\n\033[0m"
	wget -O dl/arm-trusted-firmware.tar.gz https://github.com/ARM-software/arm-trusted-firmware/archive/v2.0.tar.gz
}

[ ! -d "./arm-trusted-firmware" ] && {
	echo  "\033[32mExtracting arm-trusted-firmware...\n\033[0m"
	tar zxf dl/arm-trusted-firmware.tar.gz && {
		mv arm-trusted-firmware-* arm-trusted-firmware
	}
}

[ -f "./dl/u-boot.tar.gz" ] && {
	echo  "\033[32mU-boot already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading U-boot...\n\033[0m"
	wget -O dl/u-boot.tar.gz https://github.com/u-boot/u-boot/archive/v2020.10.tar.gz
}

[ ! -d "./u-boot" ] && {
	echo  "\033[32mExtracting U-boot...\n\033[0m"
	tar zxf dl/u-boot.tar.gz && {
		mv u-boot-* u-boot
	}
}

[ -f "./dl/optee_os.tar.gz" ] && {
	echo  "\033[32moptee_os already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading optee_os...\n\033[0m"
	wget -O dl/optee_os.tar.gz https://github.com/OP-TEE/optee_os/archive/3.20.0.tar.gz
}

[ ! -d "./optee_os" ] && {
	echo  "\033[32mExtracting optee_os...\n\033[0m"
	tar zxf dl/optee_os.tar.gz && {
		mv optee_os-* optee_os
	}
	sed -i /ta_arm32/d optee_os/core/arch/arm/plat-rpi3/conf.mk
}

[ -f "./dl/optee_client.tar.gz" ] && {
	echo  "\033[32moptee_client already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading optee_client...\n\033[0m"
	wget -O dl/optee_client.tar.gz https://github.com/OP-TEE/optee_client/archive/3.20.0.tar.gz
}

[ ! -d "./optee_client" ] && {
	echo  "\033[32mExtracting optee_client...\n\033[0m"
	tar zxf dl/optee_client.tar.gz && {
		mv optee_client-* optee_client
	}
}

[ -f "./dl/optee_examples.tar.gz" ] && {
	echo  "\033[32moptee_examples already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading optee_examples...\n\033[0m"
	wget -O dl/optee_examples.tar.gz https://github.com/linaro-swg/optee_examples/archive/3.20.0.tar.gz
}

[ ! -d "./optee_examples" ] && {
	echo  "\033[32mExtracting optee_examples...\n\033[0m"
	tar zxf dl/optee_examples.tar.gz && {
		mv optee_examples-* optee_examples
	}
}

[ ! -d "./optee_rust" ] && {
	echo  "\033[32mPulling optee_rust...\n\033[0m"
	git init optee_rust
	cd optee_rust
	git fetch --depth=1 https://github.com/apache/incubator-teaclave-trustzone-sdk b2fbfb008d426349c5ad31bac4857174522dd89c:refs/heads/main
	git checkout main
	OPTEE_DIR=$(pwd) ./setup.sh
	cd ..
}

[ -f "./dl/linux.tar.gz" ] && {
	echo  "\033[32mRPi linux kernel already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading RPi linux kernel...\n\033[0m"
	wget -O dl/linux.tar.gz https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_1.20190215-1.tar.gz
}

[ ! -d "./linux" ] && {
	echo  "\033[32mExtracting RPi linux kernel...\n\033[0m"
	tar zxf dl/linux.tar.gz && {
		mv linux-* linux
	}
}

[ -f "./dl/rpi-firmware.tar.gz" ] && {
	echo  "\033[32mRPi firmware already downloaded.\n\033[0m"
} || {
	echo  "\033[32mDownloading rpi firmware...\n\033[0m"
	wget -O dl/rpi-firmware.tar.gz https://github.com/raspberrypi/firmware/archive/refs/tags/1.20230405.tar.gz
}

[ ! -d "./rpi-firmware" ] && {
	echo  "\033[32mExtracting RPi firmware...\n\033[0m"
	tar zxf dl/rpi-firmware.tar.gz && {
		mv firmware-* rpi-firmware
	}
}


