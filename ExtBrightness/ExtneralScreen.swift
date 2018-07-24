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
//    var screenSerial: String?
    var screenName: String?
    
    var brightness: UInt8 = 50
    var maxBrightness: UInt8 = 100
        
    func setBrightness(_ newValue: UInt8) -> Bool {
        let ret = ddcSetBrightness(displayID, newValue)
        if ret {
            brightness = newValue
        }
        return ret
    }
    
    init(screenObject screen: NSScreen, displayID id: CGDirectDisplayID) {
        screenObject = screen
        displayID = id
        screenName = ddcGetScreenName(id)
    }
}
