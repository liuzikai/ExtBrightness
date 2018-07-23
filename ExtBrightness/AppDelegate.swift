//
//  AppDelegate.swift
//  ExtBrightness
//
//  Created by liuzikai on 2018/7/22.
//  Copyright © 2018 liuzikai. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItemController: StatusItemController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItemController = StatusItemController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

