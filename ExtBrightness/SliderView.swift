//
//  SliderView.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/23.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

class SliderView: NSViewController {

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var sliderValueLabel: NSTextField!
    @IBOutlet weak var screenName: NSTextField!
    
//    weak var menuItem: NSMenuItem!
    
    var externalScreen: ExtneralScreen!
    
    override func loadView() {
        super.loadView()
        
        slider.maxValue = Double(externalScreen.maxBrightness)
        slider.doubleValue = Double(externalScreen.brightness)
        sliderValueLabel.stringValue = String(Int(slider.doubleValue))
        
        screenName.stringValue = externalScreen.screenName ?? "Unknown display"
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderValueLabel.stringValue = String(Int(slider.doubleValue))
        if (!externalScreen.setBrightness(UInt8(Int(slider.doubleValue)))) {
            // If fail to set brightness, reload brightness value to the slider
            slider.doubleValue = Double(externalScreen.brightness)
        }
    }
}
