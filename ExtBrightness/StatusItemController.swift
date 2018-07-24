//
//  StatusItemController.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/22.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

/// This class handles status item and popup menu
class StatusItemController: NSObject {
    
    var statusItem: NSStatusItem!
    
    var menu: NSMenu!
    var globalCtlViewController: GlobalCtlViewController!
    var globalCtlItem: NSMenuItem!
    var sliderControllers: [SliderViewController] = []
    var quitItem: NSMenuItem!
    
    let displaysManager = DisplaysManager()
    
    
    /// Create an item on status bar
    private func createStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.target = self
        statusItem.action = #selector(statusItemClick)
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
    }
    
    /// Create common menu items, incluing global control item and quit item
    private func createCommonMenuItems() {
        globalCtlViewController = GlobalCtlViewController()
        globalCtlViewController.displaysManager = displaysManager
        globalCtlViewController.menuController = self
        
        globalCtlItem = NSMenuItem()
        globalCtlItem.view = globalCtlViewController.view
        
        quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.target = self
        quitItem.action = #selector(quitItemClick)
        
    }
    
    override init() {
        super.init()
        
        createStatusItem()
        createCommonMenuItems()
    }
    
    @objc private func statusItemClick(_ sender: Any) {
        
        // Reset menu
        menu = NSMenu()
        sliderControllers = []
        
        menu.addItem(globalCtlItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Call displaysManager to reload connected displays
        displaysManager.iterateDisplays()
        for controller in displaysManager.displayController.values {
            if controller.valid {
                let sliderController = SliderViewController()
                sliderController.displayController = controller
                
                sliderControllers.append(sliderController)
                
                let item = NSMenuItem()
                item.view = sliderController.view
                menu.addItem(item)
            }
        }
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(quitItem)
        
        statusItem.popUpMenu(menu)
    }
    
    @objc private func quitItemClick(_ sender: Any) {
        NSApp.terminate(sender)
    }
    
    func reloadAllBrightness() {
        for sliderController in sliderControllers {
            sliderController.loadDataFromDisplayController()
        }
    }
}

