SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host

all:	all-real

generate-classes:
	../.build/debug/classgenerator -cs --c-header ./Sources/bridge --cpp-header ./Sources/cpp_bridge --swift-file ./Sources/demo ./Sources/bridge/typeClassDefs/demo.gen

.include "../../../../mk/mipal.mk"

CFLAGS=-DWHITEBOARD_POSTER_STRING_CONVERSION=1
