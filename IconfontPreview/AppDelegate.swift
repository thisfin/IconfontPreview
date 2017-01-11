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

        // 菜单
        NSApplication.shared().menu = {
            let menu = NSMenu()
            menu.addItem({
                let iconfontPreviewItem = NSMenuItem()
                iconfontPreviewItem.submenu = {
                    let submenu = NSMenu()
                    submenu.addItem(NSMenuItem(title: "About \(ProcessInfo.processInfo.processName)", action: #selector(AppDelegate.about(_:)), keyEquivalent: ""))
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(NSMenuItem(title: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(AppDelegate.quit(_:)), keyEquivalent: ""))
                    return submenu
                }()
                return iconfontPreviewItem
                }())
            return menu
        }()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - NSWindowDelegate
    public func windowShouldClose(_ sender: Any) -> Bool {
        fileSelectedWindew.makeKeyAndOrderFront(self)
        fontWindow.orderOut(self)
        return false;
    }

    func about(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(self)
    }

    func quit(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
