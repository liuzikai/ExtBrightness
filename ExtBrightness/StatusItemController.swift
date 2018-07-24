//
//  StatusItemController.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/22.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    var quitMenuItem: NSMenuItem!
    var sliderControllers: [CGDirectDisplayID: SliderView] = [:]
    
    private func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.target = self
        statusItem.action = #selector(statusItemClick)
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
    }
    
    private func createPopoverAndController() {
        var viewArray: NSArray?
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PopViewController"), owner: self, topLevelObjects: &viewArray)
    }
    
    override init() {
        super.init()
        
        createStatusItem()
        createPopoverAndController()
    }
    
    fileprivate func iterateScreen() {
        for screen in NSScreen.screens {
            let descriptions = screen.deviceDescription
            if (descriptions[NSDeviceDescriptionKey.isScreen] != nil) {
                let displayID = descriptions[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
                let slider: SliderView
                if (sliderControllers.keys.contains(displayID)) {
                    slider = sliderControllers[displayID]!
                } else {
                    slider = SliderView()
                    
                    
                    let controller: DisplayController
                    
                    if (CGDisplayIsBuiltin(displayID) != 0) {
                        // Is build-in display
                        controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.BuildIn)
                    } else {
                        if (extGetBrightness(displayID, nil, nil)) {
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOnline)
                        } else {
                            controller = DisplayController(screenObject: screen, displayID: displayID, displayType: DisplayType.ExternalOffline)
                        }
                    }
                    
                    slider.displayController = controller
                    sliderControllers[displayID] = slider
                    
                    
                }
                slider.displayController.reloadBrightness()
                let item = NSMenuItem()
                item.view = slider.view
                menu.addItem(item)
            }
        }
    }
    
    @objc private func statusItemClick(_ sender: Any) {
        menu = NSMenu()
        
        iterateScreen()
        
        menu.addItem(NSMenuItem.separator())
        
        quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit"
        quitMenuItem.target = self
        quitMenuItem.action = #selector(quitMenuItemClick)
        menu.addItem(quitMenuItem)
        
        statusItem.popUpMenu(menu)
    }
    
    @objc private func quitMenuItemClick(_ sender: Any) {
        NSApp.terminate(sender)
    }
}

