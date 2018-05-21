SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host
SWIFTCFLAGS=-warnings-as-errors

all:	all-real

generate-classes:
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./demo.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./sub.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./fieldBall.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./fieldBalls.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_control_status.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_detection_ball.gen
	../.build/debug/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_detection_balls.gen

.include "../../../mk/c++11.mk"
.include "../../../mk/mipal.mk"

CFLAGS+=-DWHITEBOARD_POSTER_STRING_CONVERSION=1 -DWHITEBOARD_SERIALISATION=1 -I${SRCDIR}/bridge -Werror -Wall
