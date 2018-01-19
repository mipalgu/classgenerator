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
	ex -sc '126i|            Point2D * position = const_cast<Point2D *>(static_cast<const Point2D *>(&this->_position));' -cx ParticlePosition.h
	ex -sc '127i|            ss << "position={ " << position->description() << " }";' -cx ParticlePosition.h
	ex -sc '128i|            ss << ", ";' -cx ParticlePosition.h
	ex -sc '144i|            Point2D * position = const_cast<Point2D *>(static_cast<const Point2D *>(&this->_position));' -cx ParticlePosition.h
	ex -sc '145i|            ss << "{ " << position->to_string() << " }";' -cx ParticlePosition.h
	ex -sc '146i|            ss << ", ";' -cx ParticlePosition.h
	ex -sc '159i|            unsigned long position_index= str.find("position=");' -cx ParticlePosition.h
	ex -sc '160i|            if (position_index != std::string::npos) {' -cx ParticlePosition.h
	ex -sc '161i|                memset(&var[0], 0, sizeof(var));' -cx ParticlePosition.h
	ex -sc '162i|                int bracecount = 1;' -cx ParticlePosition.h
	ex -sc '163i|                unsigned long lastBrace = position_index;' -cx ParticlePosition.h
	ex -sc '164i|                Point2D pos = Point2D();' -cx ParticlePosition.h
	ex -sc '165i|                for (unsigned long index = position_index; index < str.length(); index++) {' -cx ParticlePosition.h
	ex -sc "166i|                    if (str.at(index) == '{') {" -cx ParticlePosition.h
	ex -sc '167i|                        bracecount++;' -cx ParticlePosition.h
	ex -sc '168i|                        lastBrace = index;' -cx ParticlePosition.h
	ex -sc '169i|                        continue;' -cx ParticlePosition.h
	ex -sc '170i|                    }' -cx ParticlePosition.h
	ex -sc "171i|                    if (str.at(index) == '}') {" -cx ParticlePosition.h
	ex -sc '172i|                        bracecount--; ' -cx ParticlePosition.h
	ex -sc '173i|                        if (bracecount < 1) {' -cx ParticlePosition.h
	ex -sc '174i|                            break;' -cx ParticlePosition.h
	ex -sc '175i|                        }' -cx ParticlePosition.h
	ex -sc '176i|                        if (bracecount != 2) {' -cx ParticlePosition.h
	ex -sc '177i|                            continue;' -cx ParticlePosition.h
	ex -sc '178i|                        }' -cx ParticlePosition.h
	ex -sc '179i|                        std::string value = str.substr(lastBrace, index - lastBrace + 1);' -cx ParticlePosition.h
	ex -sc '180i|                        pos.from_string(value);' -cx ParticlePosition.h
	ex -sc '181i|                        this->_position = Point2D(pos);' -cx ParticlePosition.h
	ex -sc '182i|                        continue;' -cx ParticlePosition.h
	ex -sc '183i|                    }' -cx ParticlePosition.h
	ex -sc '184i|                }' -cx ParticlePosition.h
	ex -sc '185i|            }' -cx ParticlePosition.h
	
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
