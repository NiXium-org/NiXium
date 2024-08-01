{ ... }:

# Hardware-acceleration management of NXC

{
	# FIXME-QA(Krey): Unsure if we need this, review post-deployment
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};
}
