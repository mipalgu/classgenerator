SWIFT=swift
DIR!=pwd

all:	swift-test

.include "../../../../mk/prefs.mk"

swift-test:
	../.build/debug/classgenerator -s --c-header ./Sources/bridge --c-file ./Sources/bridge --swift-file ./Sources/demo demo.gen
	$Eenv ${BUILD_ENV} ${SWIFT} test ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

test:	swift-test

clean:
	rm -r .build
