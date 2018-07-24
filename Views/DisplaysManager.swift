//
//  DisplaysManager.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa


/// This class manage DisplayControllers
/// When a new display is detected, a new DisplayController is instantiated and stored.
/// When a display is no longer connected, the controller is set as invalid but not released,
/// which allow brightness value to be remembered
class DisplaysManager: NSObject {
    
    var displayController: [CGDirectDisplayID: DisplayController] = [:]
    
    func iterateDisplays() {
        
        // Unset flags of all controllers
        for controller in displayController.values {
            controller.valid = false
        }
        
        for screen in NSScreen.screens {
            let descriptions = screen.deviceDescription
            if (descriptions[NSDeviceDescriptionKey.isScreen] != nil) {
                let displayID = descriptions[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
                if (displayController.keys.contains(displayID)) {
                    displayController[displayID]!.valid = true
                } else {
                    
                    let controller: DisplayController
                    
                    if (CGDisplayIsBuiltin(displayID) != 0) {
                        // Is build-in display
                        controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.BuildIn)
                    } else {
                        if (extGetBrightness(displayID, nil, nil)) {
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOnline)
                        } else {
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOffline)
                            extSleepBetweenCommands()
//                            _ = controller.setBrightness(controller.brightness)
                        }
                    }
                    
                    controller.reloadBrightness()
                    controller.valid = true
                    
                    displayController[displayID] = controller
                }
            }
        }
    }
    
    func adjustAllBrightness(_ offset: Double) {
        for controller in displayController.values {
            if controller.valid {
                _ = controller.setBrightness(controller.brightness + offset)
            }
        }
    }
    
}
