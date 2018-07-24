#import "BuildInMonitorControl.h"
#include <IOKit/graphics/IOGraphicsLib.h>


const int kMaxDisplays = 16;
const CFStringRef kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

// background thread to update the slider based on current brightness level
// polls between every 0.1 seconds to 1.0 second depending on interactivity
const float INTERACTIVE = 0.1;
const float BACKGROUND = 1.0;

// almost completely from: http://mattdanger.net/2008/12/adjust-mac-os-x-display-brightness-from-the-terminal/
float get_brightness() {
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayErr err;
    err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr)
        printf("cannot get list of displays (error %d)\n",err);
    for (CGDisplayCount i = 0; i < numDisplays; ++i) {
        
        
        CGDirectDisplayID dspy = display[i];
        CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
        if (originalMode == NULL)
            continue;
        io_service_t service = CGDisplayIOServicePort(dspy);
        
        float brightness;
        err= IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                        &brightness);
        if (err != kIOReturnSuccess) {
            fprintf(stderr,
                    "failed to get brightness of display 0x%x (error %d)",
                    (unsigned int)dspy, err);
            continue;
        }
        return brightness;
    }
    return -1.0;//couldn't get brightness for any display
}

float buildInGetBrightness(CGDirectDisplayID dspy) {
    CGDisplayErr err;
    
    CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
    if (originalMode == NULL)
        return -1.0;
    io_service_t service = CGDisplayIOServicePort(dspy);
    
    float brightness;
    err = IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                    &brightness);
    if (err != kIOReturnSuccess) {
        fprintf(stderr,
                "failed to get brightness of display 0x%x (error %d)",
                (unsigned int)dspy, err);
        return -1.0;
    }
    return brightness;
}

// almost completely from: http://mattdanger.net/2008/12/adjust-mac-os-x-display-brightness-from-the-terminal/
void set_brightness(float new_brightness) {
    CGDirectDisplayID display[kMaxDisplays];
    CGDisplayCount numDisplays;
    CGDisplayErr err;
    err = CGGetActiveDisplayList(kMaxDisplays, display, &numDisplays);
    
    if (err != CGDisplayNoErr)
        printf("cannot get list of displays (error %d)\n",err);
    for (CGDisplayCount i = 0; i < numDisplays; ++i) {
        
        
        CGDirectDisplayID dspy = display[i];
        CFDictionaryRef originalMode = CGDisplayCurrentMode(dspy);
        if (originalMode == NULL)
            continue;
        io_service_t service = CGDisplayIOServicePort(dspy);
        
        float brightness;
        err= IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                        &brightness);
        if (err != kIOReturnSuccess) {
            fprintf(stderr,
                    "failed to get brightness of display 0x%x (error %d)",
                    (unsigned int)dspy, err);
            //continue;
        }
        
        err = IODisplaySetFloatParameter(service, kNilOptions, kDisplayBrightness,
                                         new_brightness);
        if (err != kIOReturnSuccess) {
            fprintf(stderr,
                    "Failed to set brightness of display 0x%x (error %d)",
                    (unsigned int)dspy, err);
            continue;
        }
        
        if(brightness > 0.0){
        }else{
        }
    }
    
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
