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


#import "NativeMonitorControl.h"
#include <IOKit/graphics/IOGraphicsLib.h>

// Replace deprecated CGDisplayIOServicePort()
// See: https://github.com/glfw/glfw/commit/8101d7a7b67fc3414769b25944dc7c02b58d53d0
static io_service_t IOServicePortFromCGDisplayID(CGDirectDisplayID displayID)
{
    io_iterator_t iter;
    io_service_t serv, servicePort = 0;
    
    CFMutableDictionaryRef matching = IOServiceMatching("IODisplayConnect");
    
    // releases matching for us
    kern_return_t err = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                     matching,
                                                     &iter);
    if (err)
    {
        return 0;
    }
    
    while ((serv = IOIteratorNext(iter)) != 0)
    {
        CFDictionaryRef info;
        CFIndex vendorID, productID;
        CFNumberRef vendorIDRef, productIDRef;
        Boolean success;
        
        info = IODisplayCreateInfoDictionary(serv,
                                             kIODisplayOnlyPreferredName);
        
        vendorIDRef = CFDictionaryGetValue(info,
                                           CFSTR(kDisplayVendorID));
        productIDRef = CFDictionaryGetValue(info,
                                            CFSTR(kDisplayProductID));
        
        success = CFNumberGetValue(vendorIDRef, kCFNumberCFIndexType,
                                   &vendorID);
        success &= CFNumberGetValue(productIDRef, kCFNumberCFIndexType,
                                    &productID);
        
        if (!success)
        {
            CFRelease(info);
            continue;
        }
        
        if (CGDisplayVendorNumber(displayID) != vendorID ||
            CGDisplayModelNumber(displayID) != productID)
        {
            CFRelease(info);
            continue;
        }
        
        // we're a match
        servicePort = serv;
        CFRelease(info);
        break;
    }
    
    IOObjectRelease(iter);
    return servicePort;
}

const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

float nativeGetBrightness(CGDirectDisplayID dspy) {

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

bool nativeSetBrightness(CGDirectDisplayID dspy, float new_brightness) {
    CGDisplayErr err;
    
    // CGDisplayCurrentMode() is deprecated.
//    CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
//    if (originalMode == NULL)
//        return false;
    // CGDisplayIOServicePort() is deprecated.
//    io_service_t service = CGDisplayIOServicePort(dspy);
    io_service_t service = IOServicePortFromCGDisplayID(dspy);
    
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
