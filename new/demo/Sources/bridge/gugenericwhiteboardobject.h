/*
 *  gugenericwhiteboardobject.h
 *
 *  Created by Carl Lusty in 2013.
 *  Copyright (c) 2013 Carl Lusty
 *  All rights reserved.
 */

#ifndef GENERIC_WB_OBJ_H
#define GENERIC_WB_OBJ_H

#include "gusimplewhiteboard.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#pragma clang diagnostic ignored "-Wpadded"
#pragma clang diagnostic ignored "-Wc++98-compat-pedantic"
#pragma clang diagnostic ignored "-Wdeprecated"
#pragma clang diagnostic ignored "-Wreserved-id-macro"

#include <iostream>
#include <assert.h>
#include <string>
#include <vector>

#ifdef bool
#undef bool
#endif

#ifdef true
#undef true
#undef false
#endif

extern gu_simple_whiteboard_descriptor *local_whiteboard_descriptor;

/**
* @brief This class allows you to set and get data directly into or out of the local whiteboard in shared memory
*
* Examples
* --------
*
* ###Setting the Speech type
*
*     Say_t say_ptr; 			//get a pointer to the Say type within the whiteboard 
*     std::string str("Howdy World");	//make a string
*     say_ptr.set(str);			//set the string value into the Say type (and onto the whiteboard)
*     
* ###Nice overloads
*     
*     Say_t say("Howdy World");		//create the Say variable and set it to a string value in one statement. This has posted the string to the whiteboard.
*
* ###Getting data back out
*
*     std::string str;			//make a string
*     Say_t say_ptr; 			//get a pointer to the Say type within the whiteboard 
*     str = say_ptr.get();		//get the string value out of the whiteboard.
*
* ###Other types and custom classes work the same way
*
*     Walk_ControlStatus w(100, 0, 0, 100);	//create the object
*     Walk_Command_t w_ptr; 			//get a pointer to the Walk type within the whiteboard 
*     w_ptr.set(w);				//set into the whiteboard
*
*     //lets get it out again using new variables
*     Walk_ControlStatus new_w;			//create an empty object
*     Walk_Command_t new_w_ptr;			//get a pointer to the Walk type within the whiteboard 
*     new_w = new_w_ptr.get()			//get from whiteboard
*
*     //why not print it too
*     std::string new_s = new_w.description();	//get a pretty printed string of the content
*     fprintf(stdout, "%s", const_cast<char *>(new_s.c_str())); //print the content
*  
*/
template <class object_type> class generic_whiteboard_object
{
        gu_simple_whiteboard_descriptor *_wbd;
        uint16_t type_offset;
        bool atomic;
        bool notify_subscribers;

public:
        /**
         * designated constructor
         */
        generic_whiteboard_object(gu_simple_whiteboard_descriptor *wbd, uint16_t toffs, bool want_atomic = true, bool do_notify_subscribers = true) //Constructor
        {
                init(toffs, wbd, want_atomic, do_notify_subscribers);
        }

        /**
         * copy constructor
         */
        generic_whiteboard_object(const generic_whiteboard_object<object_type> &source)
        {
                init(source.type_offset, source._wbd, source.atomic, source.notify_subscribers);
        }

        /**
         * value conversion reference constructor (needs to be overridden by subclasses to set toffs to be useful)
         */
        generic_whiteboard_object(const object_type &value, uint16_t toffs, gu_simple_whiteboard_descriptor *wbd = NULL, bool want_atomic = true)
        {
                init(toffs, wbd, want_atomic);
                set(value);
        }

        /**
         * intialiser (called from constructors)
         */
        void init(uint16_t toffs, gu_simple_whiteboard_descriptor *wbd = NULL, bool want_atomic = true, bool do_notify_subscribers = true)
        {
                if(!wbd)
                {
			wbd = get_local_singleton_whiteboard();
                }
                type_offset = toffs;
                atomic = want_atomic;
                notify_subscribers = do_notify_subscribers;
                _wbd = wbd;
        }

        /**
         * designated setter for posting whiteboard messages
         */
        void set(const object_type &msg);

        /**
         * designated getter for getting a whiteboard message
         */
        object_type get()
        {
//              return *(object_type *)gsw_current_message(_wbd->wb, type_offset);
                return get_from(gsw_current_message(_wbd->wb, type_offset));
        }

        /**
         * access method to get data from an existing, low-level message
         */
        object_type get_from(gu_simple_message *msg);

        /**
         * post method (calls set())
         */
        void post(const object_type &msg) { set(msg); }

        /**
         * shift left operator (calls set())
         */
        const object_type &operator<<(const object_type &value)
        {
                set(value);

                return value;
        }

        /**
         * shift right operator (calls get())
         */
        generic_whiteboard_object<object_type> &operator>>(object_type &value)
        {
                value = get();

                return *this;
        }

        /**
         * assignment operator (calls set())
         */
        const object_type &operator=(const object_type &value)
        {
                set(value);

                return value;
        }

        /**
         * assignment copy operator (calls set())
         */
        object_type operator=(object_type value)
        {
                set(value);

                return value;
        }

        /**
         * cast operator (calls get())
         */
        operator object_type()
        {
                return get();
        }

        /**
         * empty function operator (calls get())
         */
        object_type operator()()
        {
                return get();
        }

        /**
         * function operator with object_type copy parameter (calls set())
         */
        void operator()(object_type value)
        {
                set(value);
        }
};

/** 
 * @brief Generic object method for unwrapping data from the underlying whiteboard storage union. string specialisation 
 * @param msg The union pointer
 * @return The unwrapped data in the template type
 */
template<> std::string generic_whiteboard_object<std::string>::get_from(gu_simple_message *msg);
/** 
 * @brief Generic object method for unwrapping data from the underlying whiteboard storage union. vector<int> specialisation 
 * @param msg The union pointer
 * @return The unwrapped data in the template type
 */
template<> std::vector<int> generic_whiteboard_object<std::vector<int> >::get_from(gu_simple_message *msg);
/** 
 * @brief Generic object method for unwrapping data from the underlying whiteboard storage union. vector<bool> specialisation
 * @param msg The union pointer
 * @return The unwrapped data in the template type
 */
template<> std::vector<bool> generic_whiteboard_object<std::vector<bool> >::get_from(gu_simple_message *msg);

/** 
 * @brief Generic object method for unwrapping data from the underlying whiteboard storage union. 
 * @param msg The union pointer
 * @return The unwrapped data in the template type
 */
template <typename object_type>
object_type generic_whiteboard_object<object_type>::get_from(gu_simple_message *msg)
{
        return *reinterpret_cast<object_type *>(msg);
}

/** 
 * @brief Generic object method for setting data into a specific whiteboard type. string specialisation 
 * @param msg The data to set into the whiteboard
 */
template<> void generic_whiteboard_object<std::string>::set(const std::string &msg);
/** 
 * @brief Generic object method for setting data into a specific whiteboard type. vector<int> specialisation 
 * @param msg The data to set into the whiteboard
 */
template<> void generic_whiteboard_object<std::vector<int> >::set(const std::vector<int> &msg);
/** 
 * @brief Generic object method for setting data into a specific whiteboard type. vector<bool> specialisation 
 * @param msg The data to set into the whiteboard
 */
template<> void generic_whiteboard_object<std::vector<bool> >::set(const std::vector<bool> &msg);

/** 
 * @brief Generic object method for setting data into a specific whiteboard type. 
 * @param msg The data to set into the whiteboard
 */
template <class object_type>
void generic_whiteboard_object<object_type>::set(const object_type &msg)
{
        int t = type_offset;
        
#ifndef NO_SAFETY
        assert(GU_SIMPLE_WHITEBOARD_BUFSIZE >= sizeof(object_type));
#endif
        if (atomic) gsw_procure(_wbd->sem, GSW_SEM_PUTMSG);
        
        gu_simple_whiteboard *wb = _wbd->wb;
        gu_simple_message *m = gsw_next_message(wb, t);
        object_type *wbobj = reinterpret_cast<object_type*>(m);
        *wbobj = msg;
        
        gsw_increment(wb, t);
        gsw_increment_event_counter(wb, t);
        if (atomic) gsw_vacate(_wbd->sem, GSW_SEM_PUTMSG);
        if (notify_subscribers && wb->subscribed) gsw_signal_subscribers(wb);
}

#pragma clang diagnostic pop


#endif //GENERIC_WB_OBJ_H
