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
	ex -sc '135i|                ss << (particles_first ? "" : ", ") << "{ " << (particles_element->description()) << " }";' -cx TopParticles.h
	ex -sc '136i|                particles_first = false;' -cx TopParticles.h
	ex -sc '137i|            }' -cx TopParticles.h
	ex -sc '138i|            ss << "}";' -cx TopParticles.h
	ex -sc '152i|            bool particles_first = true;' -cx TopParticles.h
	ex -sc '153i|            ss << "{";' -cx TopParticles.h
	ex -sc '154i|            for (int i = 0; i < TOPPARTICLES_PARTICLES_ARRAY_SIZE; i++) {' -cx TopParticles.h
	ex -sc '155i|                guWhiteboard::ParticlePosition * particles_element = const_cast<guWhiteboard::ParticlePosition *>(static_cast<const guWhiteboard::ParticlePosition *>(&this->particles(i)));' -cx TopParticles.h
	ex -sc '156i|                ss << (particles_first ? "" : ", ") << "{ " << (particles_element->to_string()) << " }";' -cx TopParticles.h
	ex -sc '157i|                particles_first = false;' -cx TopParticles.h
	ex -sc '158i|            }' -cx TopParticles.h
	ex -sc '159i|            ss << "}";' -cx TopParticles.h
	ex -sc '170i|            unsigned long particles_index = str.find("particles=");' -cx TopParticles.h
	ex -sc '171i|            if (particles_index != std::string::npos) {' -cx TopParticles.h
	ex -sc '172i|                memset(&var[0], 0, sizeof(var));' -cx TopParticles.h
	ex -sc '173i|                int bracecount = 1;' -cx TopParticles.h
	ex -sc '174i|                unsigned long lastBrace = particles_index;' -cx TopParticles.h
	ex -sc '175i|                ParticlePosition pos = ParticlePosition();' -cx TopParticles.h
	ex -sc '176i|                int pos_index = 0;' -cx TopParticles.h
	ex -sc '177i|                for (unsigned long index = particles_index; index < str.length(); index++) {' -cx TopParticles.h
	ex -sc "178i|                    if (str.at(index) == '{') {" -cx TopParticles.h
	ex -sc '179i|                        bracecount++;' -cx TopParticles.h
	ex -sc '180i|                        lastBrace = index;' -cx TopParticles.h
	ex -sc '181i|                        continue;' -cx TopParticles.h
	ex -sc '182i|                    }' -cx TopParticles.h
	ex -sc "183i|                    if (str.at(index) == '}') {" -cx TopParticles.h
	ex -sc '184i|                        bracecount--; ' -cx TopParticles.h
	ex -sc '185i|                        if (bracecount < 1) {' -cx TopParticles.h
	ex -sc '186i|                            break;' -cx TopParticles.h
	ex -sc '187i|                        }' -cx TopParticles.h
	ex -sc '188i|                        if (bracecount != 2) {' -cx TopParticles.h
	ex -sc '189i|                            continue;' -cx TopParticles.h
	ex -sc '190i|                        }' -cx TopParticles.h
	ex -sc '191i|                        std::string value = str.substr(lastBrace, index - lastBrace + 1);' -cx TopParticles.h
	ex -sc '192i|                        pos.from_string(value);' -cx TopParticles.h
	ex -sc '193i|                        this->_particles[pos_index++] = ParticlePosition(pos);' -cx TopParticles.h
	ex -sc '194i|                        continue;' -cx TopParticles.h
	ex -sc '195i|                    }' -cx TopParticles.h
	ex -sc '196i|                }' -cx TopParticles.h
	ex -sc '197i|            }' -cx TopParticles.h
	
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
