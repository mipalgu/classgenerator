#
#	$Id$
#
# GU swift whiteboard Makefile
#
ALL_TARGETS=host xc

SWIFT_SRCS=main.swift ClassData.swift fileio.swift GNUlicense.swift stringmanipulation.swift VariablesData.swift InputData.swift

#USE_TWO_LEVEL_SRCDIR=yes
MODULE_DIR!=pwd -P 
SRCDIR?=${MODULE_DIR}/Sources
USE_SWIFT_PACKAGE_MANAGER=NO    #Doesn't work with the Pi

.include "../../mk/mipal.mk"		# comes last!
