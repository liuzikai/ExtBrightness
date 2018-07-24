//
//  BuildInMonitorControl.h
//  ExtBrightness
//
//  This file contains helpers functions to control build-in display
//  Code is mainly extracted from [Brightness Menulet](http://www.alecjacobson.com/weblog/?p=1127)
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//

#ifndef AppController_h
#define AppController_h

#import <Cocoa/Cocoa.h>

float buildInGetBrightness(CGDirectDisplayID dspy);
bool buildInSetBrightness(CGDirectDisplayID dspy, float new_brightness);

#endif /* AppController_h */
