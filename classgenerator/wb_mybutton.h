/** 
 *  /file wb_mybutton.h 
 * 
 *  Created by YOUR NAME in YEAR. 
 *  Copyright (c) YEAR YOUR NAME. 
 *  All rights reserved. 
 */ 

#ifndef wb_mybutton_h 
#define wb_mybutton_h 

#include <gu_util.h> 


/** 
 *  ADD YOUR COMMENT DESCRIBING THE STRUCT wb_mybutton
 * 
 */ 

struct wb_mybutton 
{ 
	PROPERTY(bool, is_pressed)

#ifdef __cplusplus 

	/** Default constructor */ 
	wb_mybutton() : is_pressed(value)  {} 

	/** Copy Constructor */ 
	wb_mybutton(const  wb_mybutton &other) : 
		_is_pressed(other._is_pressed)   {} 

	/** Assignment Operator */ 
	wb_mybutton &operator= (const wb_mybutton &other) { 
		_is_pressed = other._is_pressed; 
		return *this; 
	} 
#endif 

};
