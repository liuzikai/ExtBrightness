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

NSString *ddcGetScreenName(CGDirectDisplayID displayID);
BOOL ddcSetBrightness(CGDirectDisplayID displayID, UInt8 brightness);

#endif /* ddc_helper_h */
