SWIFT=swift

all:	swift-test

.include "../../../mk/prefs.mk"

swift-build:
	$Eenv ${BUILD_ENV} ${SWIFT} build ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

swift-test:	swift-build
	$Eenv ${BUILD_ENV} ${SWIFT} test ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %} -Xlinker -lclassgenerator

clean:
	rm -r .build
