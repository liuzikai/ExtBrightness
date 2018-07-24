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
    case ExternalOnline
    case ExternalOffline
}

class DisplayController: NSObject {

    var screenObject: NSScreen!
    var displayID: CGDirectDisplayID!
    var displayType: DisplayType!
    
    var screenSerial: String?
    var screenName: String?
    
    var brightness: Double = 0.5
    
    var maxBrightness: UInt8 = 100 // For external display
    
    func reloadBrightness() {
        if (displayType == DisplayType.BuildIn) {
            brightness = Double(buildInGetBrightness(displayID))
        } else if (displayType == DisplayType.ExternalOnline) {
            var tmpBrightness: UInt8 = 0
            var tmpMaxBrightness: UInt8 = 0
            if (!extGetBrightness(displayID, &tmpBrightness, &tmpMaxBrightness)) {
                print("Fail to get external brightness")
                return;
            }
            brightness = Double(tmpBrightness) / Double(tmpMaxBrightness)
        }
    }
    
    func setBrightness(_ newValue: Double) -> Bool {
        let ret: Bool
        if (displayType == DisplayType.BuildIn) {
            ret = buildInSetBrightness(displayID, Float(newValue))
        } else {
            ret = extSetBrightness(displayID, UInt8(Int(Double(maxBrightness) * newValue)))
        }
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
