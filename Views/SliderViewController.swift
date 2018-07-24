//
//  SliderView.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/23.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

/// This class handles the slider view
/// Corresponding nib file SliderViewController will be loaded automatically
class SliderViewController: NSViewController {

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var screenName: NSTextField!
    
    weak var displayController: DisplayController!
    
    func loadDataFromDisplayController() {
        slider.maxValue = 1.0
        slider.doubleValue = displayController.brightness
        
        screenName.stringValue = displayController.screenName ?? "Unknown display"
    }
    
    override func loadView() {
        super.loadView()
        
        loadDataFromDisplayController()
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        if (!displayController.setBrightness(slider.doubleValue)) {
            // If fail to set brightness, reload brightness value to the slider
            slider.doubleValue = displayController.brightness
        }
    }
}
