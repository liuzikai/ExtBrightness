//
//  BuildInMonitorControl.m
//  ExtBrightness
//
//  This file contains helpers functions to control build-in display
//  Code is mainly extracted from [Brightness Menulet](http://www.alecjacobson.com/weblog/?p=1127)
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//


#import "BuildInMonitorControl.h"
#include <IOKit/graphics/IOGraphicsLib.h>

const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

float buildInGetBrightness(CGDirectDisplayID dspy) {

    float brightness = -1.0f;
    
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                 IOServiceMatching("IODisplayConnect"),
                                 &iterator);
    // If we were successful
    if (result == kIOReturnSuccess)
    {
        io_object_t service;
        
        while ((service = IOIteratorNext(iterator)))
        {
            IODisplayGetFloatParameter(service,
                                       kNilOptions,
                                       CFSTR(kIODisplayBrightnessKey),
                                       &brightness);
            // Let the object go
            IOObjectRelease(service);
        }
    }
    
    return brightness;
}

bool buildInSetBrightness(CGDirectDisplayID dspy, float new_brightness) {
    CGDisplayErr err;
    
    CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
    if (originalMode == NULL)
        return false;
    io_service_t service = CGDisplayIOServicePort(dspy);
    
    float brightness;
    err= IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                    &brightness);
    if (err != kIOReturnSuccess) {
        fprintf(stderr,
                "failed to get brightness of display 0x%x (error %d)",
                (unsigned int)dspy, err);
        return false;
    }
    
    err = IODisplaySetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                     new_brightness);
    if (err != kIOReturnSuccess) {
        fprintf(stderr,
                "Failed to set brightness of display 0x%x (error %d)",
                (unsigned int)dspy, err);
        return false;
    }
    return true;
}
