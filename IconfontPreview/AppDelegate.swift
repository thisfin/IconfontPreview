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
    fileprivate var hasOpenFile = false
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
                    submenu.addItem(withTitle: "About \(ProcessInfo.processInfo.processName)", action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(withTitle: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
                    return submenu
                }()
                return iconfontPreviewItem
                }())
            menu.addItem({
                let menuItem = NSMenuItem()
                menuItem.submenu = {
                    let submenu = NSMenu(title: "File")
                    submenu.addItem(withTitle: "Open...", action: #selector(NSDocumentController.openDocument(_:)), keyEquivalent: "o")
                    /*
                    submenu.addItem({
                        let recentMenuItem = NSMenuItem(title: "Open Recent", action: nil, keyEquivalent: "")
                        recentMenuItem.submenu = {
                            let recentSubmenu = NSMenu()
                            recentSubmenu.addItem(withTitle: "Clear Menu", action: #selector(NSDocumentController.clearRecentDocuments(_:)), keyEquivalent: "")
                            return recentSubmenu
                        }()
                        return recentMenuItem
                        }())*/
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(withTitle: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w") // 这个地方根据窗口变化系统会自己添加
                    return submenu
                }()
                return menuItem
                }())
            return menu
        }()

        // 启动时候打开文件选择 panel
        if !hasOpenFile {
            NSDocumentController.shared().openDocument(self)
        }
    }

    // 当 window 都关闭的时候, 显示文件选择菜单
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSDocumentController.shared().openDocument(self)
        return false
    }

    // finder 中右键打开, 执行顺序在 applicationDidFinishLaunching 前, 通过一个标志位来做空页面的传递
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        hasOpenFile = true
        NSDocumentController.shared().openDocument(withContentsOf: URL.init(fileURLWithPath: filename), display: true) { (document, b, nil) in
        }
        return true
    }
}
