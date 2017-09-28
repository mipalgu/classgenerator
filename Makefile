SWIFT=swift
DIR!=pwd

all:	all-real

all-real:	swift-test

.include "../../mk/prefs.mk"

swift-build:
	if [ ! -f "Sources/classgenerator/main.swift" ]; then \
		cp main.in Sources/classgenerator/main.swift ;\
	elif [ ! $(cmp -s "main.in" "Sources/classgenerator/main.swift") ]; then \
		cp main.in Sources/classgenerator/main.swift ; \
	fi;
	$Eenv ${BUILD_ENV} ${SWIFT} build ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

swift-test:
	rm -f Sources/classgenerator/main.swift
	$Eenv ${BUILD_ENV} ${SWIFT} test ${SWIFTCFLAGS:=-Xswiftc %} ${CFLAGS:=-Xcc %} ${LDFLAGS:=-Xlinker %}

host:	swift-build

test:	swift-test

clean:
	rm -rf .build

.include "../../mk/jenkins.mk"

xc-clean:	clean
