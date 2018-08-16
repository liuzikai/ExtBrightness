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
    var extDarknessViewController: ExtDarknessViewController!
    var extDarknessItem: NSMenuItem!
    var sliderControllers: [SliderViewController] = []
    var quitItem: NSMenuItem!
    
    let displaysManager = DisplaysManager()
    
    var updateTimer: Timer!
    
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
        
        extDarknessViewController = ExtDarknessViewController()
        extDarknessViewController.displaysManager = displaysManager
        
        extDarknessItem = NSMenuItem()
        extDarknessItem.view = extDarknessViewController.view
        
        quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.target = self
        quitItem.action = #selector(quitItemClick)
        
    }
    
    override init() {
        super.init()
        
        createStatusItem()
        createCommonMenuItems()
        displaysManager.iterateDisplays()
    }
    
    @objc private func statusItemClick(_ sender: Any) {
        
        // Reset menu
        menu = NSMenu()
        menu.delegate = self
        sliderControllers = []
        
        menu.addItem(globalCtlItem)
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(extDarknessItem)
        menu.addItem(NSMenuItem.separator())
        
        // Call displaysManager to reload connected displays
        displaysManager.iterateDisplays()
        for controller in displaysManager.displayControllers.values {
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
        
        // Add a timer to monitor brightness changes
        updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerFire), userInfo: nil, repeats: true)
        RunLoop.main.add(updateTimer, forMode: .commonModes)
        print("updateTimer inited.")
        
        statusItem.popUpMenu(menu)
    }
    
    @objc private func quitItemClick(_ sender: Any) {
        NSApp.terminate(sender)
    }
    
    @objc private func updateTimerFire(_ sender: Any) {
        for sliderController in sliderControllers {
            if sliderController.displayController.reloadBrightness() {
                sliderController.loadDataFromDisplayController()
                // Only set the slider if brightness is updated, or timer will prevent the user from sliding the slider
            }
        }
        print("updateTimer fired.")
    }
    
    func reloadAllBrightness() {
        for sliderController in sliderControllers {
            sliderController.loadDataFromDisplayController()
        }
    }
}

extension StatusItemController: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        if (updateTimer != nil) {
            if updateTimer.isValid {
                updateTimer.invalidate()
                updateTimer = nil
                print("updateTimer invalidated.")
            }
        }
    }
}
