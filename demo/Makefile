SWIFT=swift
CUSTOM_WB_NAME=custom_whiteboard
CUSTOM_WB_CLASSES=demo
ALL_TARGETS=generate-classes purge-cache host
SWIFTCFLAGS=-warnings-as-errors
SPECIFIC_CPPFLAGS=-DWHITEBOARD_POSTER_STRING_CONVERSION=1 -DWHITEBOARD_SERIALISATION=1 -I${SRCDIR}/bridge -Werror -Wall -Weverything -Wno-newline-eof -Wno-padded -Wno-sign-conversion \
	       	-Wno-unused-parameter -Wno-poison-system-directories -Wno-gnu-empty-initializer -Wno-implicit-int-conversion -Wno-c++11-long-long

all:	all-real

generate-classes:
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./demo.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./sub.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./fieldBall.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./fieldBalls.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./machine_filtered_localisation_vision.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./landmark_sighting.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./vision_control_status.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./vision_detection_ball.gen
	../.build/${SWIFT_BUILD_CONFIG}/classgenerator -n wb:guWhiteboard --c-header ./Sources/bridge --swift-file ./Sources/demo --squash-defines ./vision_detection_balls.gen

.include "../../../mk/c++11.mk"
.include "../../../mk/mipal.mk"
