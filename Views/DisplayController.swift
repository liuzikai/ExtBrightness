//
//  DisplayController.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/22.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

enum DisplayType {
    case BuildIn
    // Build-in displays are accessed with buildinSet/GetBrightness(), which uses Cocoa APIs
    
    case ExternalOnline      // 'Online' means brightness values can be retrieved with DDC
    case ExternalOffline     // 'Offline' means brightness values can only be set but not read with DDC
    // External displays are accessed with extSet/GetBrightness(), which uses DDC for communication
}

/// This class handle displays parameters
class DisplayController: NSObject {

    var valid = false
    // If a display is no longer accessible, its controller is set as invalid but not release,
    // which allows brightness values to be kept for offline external display
    
    var screenObject: NSScreen!
    var displayID: CGDirectDisplayID!
    var displayType: DisplayType!
    
    var screenSerial: String?
    var screenName: String?
    
    var brightness: Double = 0.5  // Range: 0.0 - 1.0
    
                                   // For internal display, the brightness range is 0.0 to 1.0
    var maxBrightness: UInt8 = 100 // For external display, the brightness range depends on monitor
    //TODO: make maxBrightness configurable
    
    func reloadBrightness() -> Bool {
        let newValue: Double
        if (displayType == DisplayType.BuildIn) {
            newValue = Double(buildInGetBrightness(displayID))
            if 0.0 <= newValue && newValue <= 1.0 {
                
            } else {
                print("Internal brightness invalid.")
                return false
            }
        } else if (displayType == DisplayType.ExternalOnline) {
            var tmpBrightness: UInt8 = 0
            var tmpMaxBrightness: UInt8 = 0
            if (!extGetBrightness(displayID, &tmpBrightness, &tmpMaxBrightness)) {
                print("Fail to get external brightness.")
                return false;
            }
            newValue = Double(tmpBrightness) / Double(tmpMaxBrightness)
        } else {
            return false
        }
        if newValue != brightness {
            brightness = newValue
            return true
        } else {
            return false
        }
    }
    
    func setBrightness(_ newValue: Double) -> Bool {
        let ret: Bool
        if (displayType == DisplayType.BuildIn) {
            ret = buildInSetBrightness(displayID, Float(newValue))
        } else {
            ret = extSetBrightness(displayID, UInt8(Int(Double(maxBrightness) * newValue)))
        }
        // If fail to set new value, do not update stored brightness value
        if ret {
            brightness = newValue
        }
        return ret
    }
    
    init(screenObject screen: NSScreen, displayID id: CGDirectDisplayID, displayType type: DisplayType) {
        screenObject = screen
        displayID = id
        displayType = type
        if (displayType == DisplayType.BuildIn) {
            screenName = "Build-In Display"
        } else {
            screenName = extGetScreenName(id)
        }

    }
}
