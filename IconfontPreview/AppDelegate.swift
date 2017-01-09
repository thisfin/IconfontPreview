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
        window = NSWindow()
        window.styleMask = [.closable, .miniaturizable, .titled]
//        window.center()
//        window.makeKeyAndOrderFront(self)

        fileSelectedWindew = NSWindow()
        fileSelectedWindew.styleMask = [.closable, .titled]
        fileSelectedWindew.contentViewController = {
            let controller = FileSelectedViewController()
            controller.nextWindowAction = {(ttfFilePath, cssFilePath) in
                self.window.contentViewController = {
                    let fontController = ViewController()
                    fontController.cssFilePath = cssFilePath
                    return fontController
                }()
                self.window.center()
                self.fileSelectedWindew.orderOut(self)
                self.window.makeKeyAndOrderFront(self)
            }
            return controller
        }()
        fileSelectedWindew.title = "Select File"
        fileSelectedWindew.center()
        fileSelectedWindew.makeKeyAndOrderFront(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
