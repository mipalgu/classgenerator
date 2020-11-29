SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes host
SWIFTCFLAGS=-warnings-as-errors
SPECIFIC_CFLAGS=-DWHITEBOARD_POSTER_STRING_CONVERSION=1 -DWHITEBOARD_SERIALISATION=1 -I${SRCDIR}/bridge -Werror -Wall

all:	all-real

generate-classes:
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./demo.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./sub.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./fieldBall.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./fieldBalls.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_control_status.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_detection_ball.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator --c-header ./Sources/bridge --swift-file ./Sources/demo ./vision_detection_balls.gen

.include "../../../mk/c++11.mk"
.include "../../../mk/mipal.mk"
