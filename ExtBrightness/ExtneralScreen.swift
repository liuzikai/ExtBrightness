//
//  ExtneralScreen.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/22.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

class ExtneralScreen: NSObject {

    var screenObject: NSScreen!
    
    var displayID: CGDirectDisplayID!
    
    var brightness: UInt8 = 50
    var maxBrightness: UInt8 = 100
    
        
    func setBrightness(_ newValue: UInt8) -> Bool {

        var ddcWriteCommand: DDCWriteCommand = DDCWriteCommand(control_id: UInt8(BRIGHTNESS), new_value: newValue)
        let ret: Bool = Bool(DDCWrite(displayID, &ddcWriteCommand))
        if ret {
            brightness = newValue
        }
        return ret
    }
    
    init(withScreenObject screen: NSScreen) {
        screenObject = screen
        let description = screenObject.deviceDescription
        displayID = description[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
    }
    
    init(withDisplayID id: CGDirectDisplayID) {
        displayID = id
    }
}
