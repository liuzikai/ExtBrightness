//
//  ddc_helper.h
//  ExtBrightness
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

#endif /* ddc_helper_h */
