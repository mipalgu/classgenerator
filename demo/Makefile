SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host

all:	all-real

generate-classes:
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./demo.gen

.include "../../../mk/mipal.mk"

CFLAGS=-DWHITEBOARD_POSTER_STRING_CONVERSION=1 -I${SRCDIR}/bridge
