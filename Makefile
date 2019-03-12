SWIFT=swift
DIR!=pwd

ALL_TARGETS=test

SWIFTCFLAGS=-warnings-as-errors

all:	all-real

all-real:	test

.include "../../mk/prefs.mk"

swift-build:
	if [ ! -f "Sources/classgenerator/main.swift" ]; then \
		cp main.in Sources/classgenerator/main.swift ;\
	elif [ ! $(cmp -s "main.in" "Sources/classgenerator/main.swift") ]; then \
		cp main.in Sources/classgenerator/main.swift ; \
	fi;
	$Eenv ${BUILD_ENV} ${SWIFT} build -c ${SWIFT_BUILD_CONFIG} ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

swift-test:
	rm -f Sources/classgenerator/main.swift
	$Eenv ${BUILD_ENV} ${SWIFT} test -c ${SWIFT_BUILD_CONFIG} ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

host:	swift-build

test:	swift-test

install: host
	cp .build/${SWIFT_BUILD_CONFIG}/classgenerator /usr/local/bin

clean:
	-rm -rf .build
	-rm -rf Package.resolved
	-rm -rf demo/.build
	-rm -rf demo/Package.resolved

.include "../../mk/jenkins.mk"

xc-clean:	clean

generate-xcodeproj:
	if [ ! -f "Sources/classgenerator/main.swift" ]; then \
		cp main.in Sources/classgenerator/main.swift ;\
	elif [ ! $(cmp -s "main.in" "Sources/classgenerator/main.swift") ]; then \
		cp main.in Sources/classgenerator/main.swift ; \
	fi;
	$Ecp config.sh.in config.sh
	$Eecho "CCFLAGS=\"${CFLAGS:C,(.*),-Xcc \1,g}\"" >> config.sh
	$Eecho "LINKFLAGS=\"${LDFLAGS:C,(.*),-Xlinker \1,g}\"" >> config.sh
	$Eecho "SWIFTCFLAGS=\"${SWIFTCFLAGS:C,(.*),-Xswiftc \1,g}\"" >> config.sh
	$E./xcodegen.sh
