{ ... }:

# Hardware-acceleration management of TSVETAN

{
	hardware.opengl = {
		enable = true;
		driSupport = true;

		# FIXME-QA(Krey): 'Option driSupport32Bit only makes sense on a 64-bit system', but this is a 64-bit system?
		driSupport32Bit = false;
	};
}
