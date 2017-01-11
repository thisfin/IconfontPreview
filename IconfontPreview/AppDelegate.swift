//
//  AppDelegate.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/7.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var fontWindow: NSWindow!
    var fileSelectedWindew: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        fontWindow = NSWindow()
        fontWindow.delegate = self;
        fontWindow.styleMask = [.closable, .miniaturizable, .titled]
//        fontWindow.center()
//        fontWindow.makeKeyAndOrderFront(self)

        fileSelectedWindew = NSWindow()
        fileSelectedWindew.styleMask = [.closable, .titled]
        fileSelectedWindew.contentViewController = {
            let controller = FileSelectedViewController()
            controller.nextWindowAction = {(characterInfos) in
                self.fontWindow.contentViewController = {
                    let fontController = FontViewController()
                    fontController.characterInfos = characterInfos
                    return fontController
                }()
                self.fontWindow.center()
                self.fontWindow.makeKeyAndOrderFront(self)
                self.fileSelectedWindew.orderOut(self)
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

    public func windowShouldClose(_ sender: Any) -> Bool {
        fileSelectedWindew.makeKeyAndOrderFront(self)
        fontWindow.orderOut(self)
        return false;
    }}
