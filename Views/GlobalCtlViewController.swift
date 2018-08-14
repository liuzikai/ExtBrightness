//
//  GlobalCtlViewController.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/24.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

/// This class handle the global control view
/// Corresponding nib file GlobalCtlViewController will be loaded automatically
class GlobalCtlViewController: NSViewController {
    
    weak var displaysManager: DisplaysManager!
    weak var menuController: StatusItemController!
    
    let smallOffset: Double = 0.02   // When option is pressed, adjust brightness with smaller steps
    let normalOffset: Double = 0.05
    let largeOffset: Double = 0.1    // When shift is pressed, adjust brightness with larger steps
    
    
    /// Return the step offset based on the state of function keys
    var offset: Double {
        let event = NSApp.currentEvent!
        if (event.modifierFlags.contains(.option)) {
            return smallOffset
        } else if (event.modifierFlags.contains(.shift)) {
            return largeOffset
        } else {
            return normalOffset
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        displaysManager.adjustAllBrightness(-offset)
        menuController.reloadAllBrightness()
    }
    
    @IBAction func plusButtonClick(_ sender: Any) {
        displaysManager.adjustAllBrightness(offset)
        menuController.reloadAllBrightness()
    }
    
}
