# NixOS + Proxmox Hypervisor with SPICE and VirtIO-GPU 

## spiceproxy works!

I could not find any code to enable this, maybe it's out there but I did not see it. I created a pull request upstream [here](https://github.com/SaumonNet/proxmox-nixos/pull/110).

## Overview

This is my config for running the Proxmox Hypervisor on NixOS with SPICE working. After trying it out and getting a Debian 12 VM running, I encountered an issue where SPICE was not functioning. It turned out that there was just a stub commented out in the `proxmox-nixos` repository. I added the necessary code in my flake.nix to make sure it is started with systemd. 

Currently, SPICE with qxl or virtio/VirtIO-GPU works. virt-viewer automatically opens and resizes as expected when using the Console -> SPICE option with virtio. However, VirtIO-GL is not yet working on my system.

## Features

- **SPICE (qxl)**: Working
- **VirGL GPU (virtio-gl)**: Not working yet
- **VirtIO-GPU (virtio)**: Working (virt-viewer opens automatically and resizes)

## Setup

1. **Proxmox Hypervisor Setup on NixOS**
   I followed the [Proxmox Hypervisor setup on NixOS](https://github.com/SaumonNet/proxmox-nixos) instructions to get started (using a flake). 

2. **SPICE Configuration**
   The SPICE section in the `proxmox-nixos` code was initially commented out (see the code [here](https://github.com/SaumonNet/proxmox-nixos/blob/15187a4c4ac50d1a38c734f72dd201a7eb504a89/modules/proxmox-ve/manager.nix#L171-L173)). I modified my flake to make sure spiceproxy is included and started by systemd.

3. **VirtIO-GPU Setup**
   VirtIO-GPU (virt-viewer) opens automatically and resizes when using the Console -> SPICE option.


## Known Issues

- **VirtIO-GL**: Not working yet. If you try to enable VirGL GPU, you will encounter an error message about missing libraries.
  
  ```bash
  Hardware > Display > VirGL GPU
  TASK ERROR: missing libraries for 'virtio-gl' detected! Please install 'libgl1' and 'libegl1'
  ```

- **Missing Libraries**: These were installed on my machine:
  
  ```bash
  $ ls /run/opengl-driver/lib/
  amdvlk64.so             libGLESv2.so          libOpenGL.so
  d3d                     libGLESv2.so.2        libOpenGL.so.0
  dri                     libGLESv2.so.2.1.0    libOpenGL.so.0.0.0
  libEGL.la               libGL.la              libVkLayer_INTEL_nullhw.so
  libEGL_mesa.so          libGL.so              libVkLayer_MESA_device_select.so
  libEGL_mesa.so.0        libGL.so.1            libVkLayer_MESA_overlay.so
  libEGL_mesa.so.0.0.0    libGL.so.1.7.0        libvulkan_dzn.so
  libEGL.so               libGLU.a              libvulkan_intel_hasvk.so
  libEGL.so.1             libGLU.so             libvulkan_intel.so
  libEGL.so.1.1.0         libGLU.so.1           libvulkan_lvp.so
  libGLdispatch.la        libGLU.so.1.3.1       libvulkan_nouveau.so
  libGLdispatch.so        libGLX.la             libvulkan_radeon.so
  libGLdispatch.so.0      libGLX_mesa.so        libvulkan_virtio.so
  libGLdispatch.so.0.0.0  libGLX_mesa.so.0      libxatracker.so
  libGLESv1_CM.la         libGLX_mesa.so.0.0.0  libxatracker.so.2
  libGLESv1_CM.so         libGLX.so             libxatracker.so.2.5.0
  libGLESv1_CM.so.1       libGLX.so.0           vdpau
  libGLESv1_CM.so.1.2.0   libGLX.so.0.0.0
  libGLESv2.la            libOpenGL.la
  ```

I've only been using NixOS for two days, but this is working so I thought I'd put it out there. I'm sure there are better ways to handle a couple of things, but SPICE with QXL and VirtIO-GPU are working.

### My Hardware Information (in case it's useful to someone)

```bash
$ cat /proc/cpuinfo 
processor    : 0
vendor_id    : AuthenticAMD
cpu family   : 23
model        : 104
model name   : AMD Ryzen 7 5700U with Radeon Graphics
```

## License

This project is licensed under the MIT License.


