SWIFT=swift
DIR!=pwd

all:	swift-test

.include "../../../mk/prefs.mk"

swift-build:
	cp main.in Sources/classgenerator/main.swift
	$Eenv ${BUILD_ENV} ${SWIFT} build ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

swift-test:	swift-build
	rm -f Sources/classgenerator/main.swift
	$Eenv ${BUILD_ENV} ${SWIFT} test ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

test:	swift-test

clean:
	rm -r .build
