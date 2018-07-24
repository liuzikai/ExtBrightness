//
//  ddc_helper.m
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ddc_helper.h"

NSString *getEDIDString(char *string)
{
    NSString *temp = [[NSString alloc] initWithBytes:string length:13 encoding:NSASCIIStringEncoding];
    return ([temp rangeOfString:@"\n"].location != NSNotFound) ? [[temp componentsSeparatedByString:@"\n"] objectAtIndex:0] : temp;
}

NSString *ddcGetScreenName(CGDirectDisplayID displayID) {
    struct EDID edid = {};
    if (EDIDTest(displayID, &edid)) {
        for (union descriptor *des = edid.descriptors; des < edid.descriptors + sizeof(edid.descriptors); des++) {
            if (des->text.type == 0xFC) {
                return getEDIDString(des->text.data);
            }
        }
    }
    return nil;
}

BOOL ddcSetBrightness(CGDirectDisplayID displayID, UInt8 brightness) {
    struct DDCWriteCommand command = {BRIGHTNESS, brightness};
    return DDCWrite(displayID, &command);
}
