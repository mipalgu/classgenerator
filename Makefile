#
#	$Id$
#
# GU swift whiteboard Makefile
#
ALL_TARGETS=host xc

all: all-real

install:
	install -m 0555 ${OUTPATH:Q} ${DESTDIR:Q}${PREFIX:Q}/bin

.include "../../mk/mipal.mk"		# comes last!
