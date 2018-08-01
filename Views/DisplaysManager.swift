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
        
        // Iterate through screen objects
        for screen in NSScreen.screens {
            let descriptions = screen.deviceDescription
            if (descriptions[NSDeviceDescriptionKey.isScreen] != nil) {
                
                let displayID = descriptions[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
                
                let controller: DisplayController
                
                if (displayController.keys.contains(displayID)) {
                    // If there is already a controller for the display, set it as valid and it will show in the popover.
                    controller = displayController[displayID]!
                } else {
                    // If not, create a new controller

                    if (CGDisplayIsBuiltin(displayID) != 0) {
                        // Is build-in display
                        controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.BuildIn)
                    } else {
                        // Is external display
                        if (extGetBrightness(displayID, nil, nil)) {
                            // If the program can get the brightness value, the display will classified as "online."
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOnline)
                        } else {
                            // If not, it will be classified as "offline."
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOffline)
//                            extSleepBetweenCommands()
//                            _ = controller.setBrightness(controller.brightness)
                        }
                    }
                    
                    displayController[displayID] = controller
                }
                
                controller.reloadBrightness()
                controller.valid = true
            }
        }
    }
    
    func adjustAllBrightness(_ offset: Double) {
        for controller in displayController.values {
            if controller.valid {
                var newValue = controller.brightness + offset
                // Clip brightness value
                if newValue < 0.0 {
                    newValue = 0.0
                } else if newValue > 1.0 {
                    newValue = 1.0
                }
                _ = controller.setBrightness(newValue)
            }
        }
    }
    
}
