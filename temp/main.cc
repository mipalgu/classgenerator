#include <stdio.h>
#include <stdlib.h>

#include <iostream>

#define WHITEBOARD_POSTER_STRING_CONVERSION 1

#include "TopParticles.h"
#include "ParticlePosition.h"

using namespace guWhiteboard;

int main() {
    TopParticles p = TopParticles();
    std::cout << p.description() << std::endl;
    std::cout << p.to_string() << std::endl;
    p.set_particles(ParticlePosition(Point2D(10, 11), 1), 0);
    p.set_particles(ParticlePosition(Point2D(12, 13), 2), 1);
    p.set_particles(ParticlePosition(Point2D(14, 15), 3), 2);
    p.set_particles(ParticlePosition(Point2D(16, 17), 4), 3);
    TopParticles p2 = TopParticles();
    p2.from_string(p.description());
    std::cout << p2.description() << std::endl;
    return EXIT_SUCCESS;
}

