//
//  ExtDarknessViewController.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/8/16.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

class ExtDarknessViewController: NSViewController {

    var displaysManager: DisplaysManager!
    
    @IBOutlet weak var darknessSlider: NSSlider!
    @IBOutlet weak var darknessLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func darknessSliderChange(_ sender: Any) {
        displaysManager.setGlobalExtDarkness(Float(darknessSlider.doubleValue / 100.0))
        darknessLabel.stringValue = "ExtDarkness: " + String(Int(darknessSlider.doubleValue)) + "%"
    }
}
