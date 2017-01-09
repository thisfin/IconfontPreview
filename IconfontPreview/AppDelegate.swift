//
//  AppDelegate.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/7.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var fileSelectedWindew: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        window = NSWindow()
//        window.styleMask = [.closable, .miniaturizable, .titled]
//        window.contentViewController = ViewController()
//        window.center()
//        window.makeKeyAndOrderFront(self)

        fileSelectedWindew = NSWindow()
        fileSelectedWindew.styleMask = [.closable, .titled]
        fileSelectedWindew.contentViewController = FileSelectedViewController()
        fileSelectedWindew.title = "Select File"
        fileSelectedWindew.center()
        fileSelectedWindew.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
