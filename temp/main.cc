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
    ParticlePosition ps[4] = {ParticlePosition(wb_point2D(), 1), ParticlePosition(wb_point2D(), 2), ParticlePosition(wb_point2D(), 3), ParticlePosition(wb_point2D(), 4)};
    p.set_particles(ps[0], 0);
    p.set_particles(ps[1], 1);
    p.set_particles(ps[2], 2);
    p.set_particles(ps[3], 3);
    std::cout << p.description() << std::endl;
    return EXIT_SUCCESS;
}

