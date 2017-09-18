SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host

all:	all-real

generate-classes:
	../.build/debug/classgenerator -s --c-header ./Sources/bridge --c-file ./Sources/bridge --swift-file ./Sources/demo demo.gen

.include "../../../../mk/whiteboard_custom.mk"
.include "../../../../mk/mipal.mk"
