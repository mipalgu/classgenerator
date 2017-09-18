SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host

all:	all-real

generate-classes:
	../.build/debug/classgenerator -s --c-header ./Sources/bridge --c-file ./Sources/bridge --swift-file ./Sources/demo ./Sources/custom_whiteboard/typeClassDefs/demo.gen

.include "../../../../mk/mipal.mk"

CFLAGS=-I${GUNAO_DIR}/Common -I${GUNAO_DIR}/posix/classgenerator/new/demo/Sources/custom_whiteboard/include
