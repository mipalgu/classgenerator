SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host

all:	all-real

generate-classes:
	../.build/debug/classgenerator -s --c-header ./Sources/bridge --c-file ./Sources/bridge --swift-file ./Sources/demo ./Sources/bridge/typeClassDefs/demo.gen

.include "../../../../mk/mipal.mk"
