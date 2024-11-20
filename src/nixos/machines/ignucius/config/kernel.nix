{ ... }:

# Kernel Management of IGNUCIUS

{
	boot.kernelModules = [
		"kvm-intel" # Use KVM
		"usb-storage" # Use USB drives on hardened kernel
	];
}
