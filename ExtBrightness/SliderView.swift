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
    var externalScreen: ExtneralScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        slider.maxValue = Double(externalScreen.maxBrightness)
        slider.doubleValue = Double(externalScreen.brightness)
    }
    
    @IBAction func sliderChange(_ sender: Any) {
        _ = externalScreen.setBrightness(UInt8(Int(slider.doubleValue)))
    }
}
