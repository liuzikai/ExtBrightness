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
    var menuItems: [NSMenuItem] = []
    var viewControllers: [SliderView] = []
    
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
    
    @objc private func statusItemClick(_ sender: Any) {
        menu = NSMenu()
        for screen in NSScreen.screens {
            let description = screen.deviceDescription
            let displayID = description[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
            if (CGDisplayIsBuiltin(displayID) == 0) {
                let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
                let controller = SliderView()
                controller.loadView()
                controller.externalScreen = ExtneralScreen.init(withDisplayID: displayID)
                item.view = controller.view
                menuItems.append(item)
                viewControllers.append(controller)
                menu.addItem(item)
            }
        }
        statusItem.popUpMenu(menu)
    }
    
}

