//
//  AppDelegate.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/7.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject {
}

extension AppDelegate: NSApplicationDelegate {
    // 自定义的 NSDocumentController 在此初始化, 因为是单例, 之后 NSDocumentController.shared() / DocumentController.shared() 效果一样
    func applicationWillFinishLaunching(_ notification: Notification) {
        DocumentController.shared()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 菜单
        NSApplication.shared().menu = {
            let menu = NSMenu()
            menu.addItem({
                let iconfontPreviewItem = NSMenuItem()
                iconfontPreviewItem.submenu = {
                    let submenu = NSMenu()
                    submenu.addItem(NSMenuItem(title: "About \(ProcessInfo.processInfo.processName)", action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(NSMenuItem(title: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
                    return submenu
                }()
                return iconfontPreviewItem
                }())
            menu.addItem({
                let menuItem = NSMenuItem()
                menuItem.submenu = {
                    let submenu = NSMenu(title: "File")
                    submenu.addItem(NSMenuItem(title: "Open...", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o"))
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(NSMenuItem(title: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"))
                    return submenu
                }()
                return menuItem
                }())
            return menu
        }()

        // 启动时候打开文件选择 panel
        NSDocumentController.shared().openDocument(self)
    }

    // 当 window 都关闭的时候, 显示文件选择菜单
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSDocumentController.shared().openDocument(self)
        return false
    }
}
