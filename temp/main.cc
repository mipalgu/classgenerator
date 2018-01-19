#include <stdio.h>
#include <stdlib.h>

#include <iostream>

#define WHITEBOARD_POSTER_STRING_CONVERSION 1

#include "TopParticles.h"

int main() {
    guWhiteboard::TopParticles p = guWhiteboard::TopParticles();
    std::cout << p.description() << std::endl;
    std::cout << p.to_string() << std::endl;
    return EXIT_SUCCESS;
}

