SWIFT=swift
DIR!=pwd

ALL_TARGETS=test

SWIFTCFLAGS=-warnings-as-errors


install: host
	cp .build/${SWIFT_BUILD_CONFIG}/classgenerator /usr/local/bin


generate-xcodeproj:
	$Ecp config.sh.in config.sh
	$Eecho "CCFLAGS=\"${CFLAGS:C,(.*),-Xcc \1,g}\"" >> config.sh
	$Eecho "LINKFLAGS=\"${LDFLAGS:C,(.*),-Xlinker \1,g}\"" >> config.sh
	$Eecho "SWIFTCFLAGS=\"${SWIFTCFLAGS:C,(.*),-Xswiftc \1,g}\"" >> config.sh
	$E./xcodegen.sh

.include "../../mk/mipal.mk"
