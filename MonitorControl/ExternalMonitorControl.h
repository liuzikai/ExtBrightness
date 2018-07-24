//
//  ddc_helper.h
//  ExtBrightness
//
//  This file contains helpers functions to control external display
//  Inspired by [kfix/ddcctl](https://github.com/kfix/ddcctl)
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//

#ifndef ddc_helper_h
#define ddc_helper_h

#import "DDC.h"

NSString *extGetScreenName(CGDirectDisplayID displayID);
BOOL extSetBrightness(CGDirectDisplayID displayID, UInt8 brightness);
BOOL extGetBrightness(CGDirectDisplayID displayID, UInt8 *brightness, UInt8 *maxValue);
void extSleepBetweenCommands(void);

#endif /* ddc_helper_h */
