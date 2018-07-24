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
    var viewControllers: [CGDirectDisplayID: SliderView] = [:]
    
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
                if (CGDisplayIsBuiltin(displayID) == 0) {
                    
                    let controller: SliderView
                    if (viewControllers.keys.contains(displayID)) {
                        controller = viewControllers[displayID]!
                    } else {
                        controller = SliderView()
                        controller.externalScreen = ExtneralScreen(screenObject: screen, displayID: displayID)
                        viewControllers[displayID] = controller
                    }
                    
                    let item = NSMenuItem()
                    item.view = controller.view
                    menu.addItem(item)
                }
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

