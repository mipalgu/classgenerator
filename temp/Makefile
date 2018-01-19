#
#	$Id$
#
# GU localisation module Makefile
#
ALL_TARGETS=host

CC_SRCS=main.cc
CFLAGS=-Wno-unused-variable

#CFLAGS=-stdlib=libc++
#LDFLAGS=-stdlib=libc++ 

all: all-real

gen:
	classgenerator Point2D.txt
	classgenerator Particle_Position.gen
	classgenerator TopParticles.gen
	ex -sc '131i|            bool particles_first = true;' -cx TopParticles.h
	ex -sc '132i|            ss << "particles={";' -cx TopParticles.h
	ex -sc '133i|            for (int i = 0; i < TOPPARTICLES_PARTICLES_ARRAY_SIZE; i++) {' -cx TopParticles.h
	ex -sc '134i|                guWhiteboard::ParticlePosition * particles_element = const_cast<guWhiteboard::ParticlePosition *>(static_cast<const guWhiteboard::ParticlePosition *>(&this->particles(i)));' -cx TopParticles.h
	ex -sc '135i|                ss << (particles_first ? "" : ", ") << "{" << (particles_element->description()) << "}";' -cx TopParticles.h
	ex -sc '136i|                particles_first = false;' -cx TopParticles.h
	ex -sc '137i|            }' -cx TopParticles.h
	ex -sc '138i|            ss << "}";' -cx TopParticles.h
	ex -sc '152i|            bool particles_first = true;' -cx TopParticles.h
	ex -sc '153i|            ss << "{";' -cx TopParticles.h
	ex -sc '154i|            for (int i = 0; i < TOPPARTICLES_PARTICLES_ARRAY_SIZE; i++) {' -cx TopParticles.h
	ex -sc '155i|                guWhiteboard::ParticlePosition * particles_element = const_cast<guWhiteboard::ParticlePosition *>(static_cast<const guWhiteboard::ParticlePosition *>(&this->particles(i)));' -cx TopParticles.h
	ex -sc '156i|                ss << (particles_first ? "" : ", ") << "{" << (particles_element->to_string()) << "}";' -cx TopParticles.h
	ex -sc '157i|                particles_first = false;' -cx TopParticles.h
	ex -sc '158i|            }' -cx TopParticles.h
	ex -sc '159i|            ss << "}";' -cx TopParticles.h
	
cleangen:
	rm -f wb_point2D.h
	rm -f wb_point2D.c
	rm -f Point2D.h
	rm -f Point2D.swift
	rm -f wb_particle_position.h
	rm -f wb_particle_position.c
	rm -f ParticlePosition.h
	rm -f ParticlePosition.swift
	rm -f wb_top_particles.h
	rm -f wb_top_particles.c
	rm -f TopParticles.h
	rm -f TopParticles.swift

.include "../../../mk/mipal.mk"		# comes last!

CFLAGS=-Wno-unused-variable -Wno-unused-parameter
