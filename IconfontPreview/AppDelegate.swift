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
    var fontWindow: NSWindow!
    var fileSelectedWindew: NSWindow!

    var twindow: NSWindow!

    var document: NSDocument!

    fileprivate var windows = [NSWindow]()



    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        fontWindow = NSWindow()
//        fontWindow.delegate = self;
//        fontWindow.styleMask = [.closable, .resizable, .miniaturizable, .titled]
//
//        fileSelectedWindew = NSWindow()
//        fileSelectedWindew.isReleasedWhenClosed = false
//        fileSelectedWindew.styleMask = [.closable, .titled]
//        fileSelectedWindew.contentViewController = {
//            let controller = FileSelectedViewController()
//            controller.nextWindowAction = {(characterInfos) in
//                self.fontWindow.contentViewController = {
//                    let fontController = FontViewController()
//                        fontController.characterInfos = IconTool.sharedInstance.datas
////                    fontController.characterInfos = characterInfos
//                    return fontController
//                }()
//                self.fontWindow.center()
//                self.fontWindow.makeKeyAndOrderFront(self)
//                self.fileSelectedWindew.orderOut(self)
//            }
//            return controller
//        }()
//        fileSelectedWindew.title = "Select File"
//        fileSelectedWindew.center()
//        fileSelectedWindew.makeKeyAndOrderFront(self)

        // 菜单
        NSApplication.shared().menu = {
            let menu = NSMenu()
            menu.addItem({
                let iconfontPreviewItem = NSMenuItem()
                iconfontPreviewItem.submenu = {
                    let submenu = NSMenu()
                    submenu.addItem(NSMenuItem(title: "Open...", action: #selector(AppDelegate.open(_:)), keyEquivalent: "o"))
                    submenu.addItem(NSMenuItem.separator())
                    submenu.addItem(NSMenuItem(title: "About \(ProcessInfo.processInfo.processName)", action: #selector(AppDelegate.about(_:)), keyEquivalent: ""))
                    submenu.addItem(NSMenuItem(title: "Quit \(ProcessInfo.processInfo.processName)", action: #selector(AppDelegate.quit(_:)), keyEquivalent: "q"))
                    return submenu
                }()
                return iconfontPreviewItem
                }())
            return menu
        }()

        open(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - NSWindowDelegate
//    public func windowShouldClose(_ sender: Any) -> Bool {
//        if let window = sender as? NSWindow, let index = windows.index(of: window) {
//            windows.remove(at: index)
//        }
//        return true

//        fileSelectedWindew.makeKeyAndOrderFront(self)
//        fontWindow.orderOut(self)
//        return false;
//    }

//    public func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
//        fileSelectedWindew.setIsVisible(true)
//        return true
//    }

    func open(_ sender: NSMenuItem?) {
        document = NSDocument.init()

        let documentController = NSDocumentController.init()
        documentController.beginOpenPanel { (urls) in
            if let urlArray = urls {
                print(urlArray.count)
            }
        }


        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["ttf"]
        panel.message = "select .ttf file"
        panel.begin { (handle) in
            if handle == NSFileHandlingPanelOKButton, let url = panel.url, let fontManager = FontManager(url: url) {
                UserDefaults.standard.set(url, forKey: "url")

                let window = NSWindow(contentRect: CGRect(origin: .zero, size: NSMakeSize(800, 600)), styleMask: [.closable, .resizable, .miniaturizable, .titled], backing: .buffered, defer: false)
                window.title = fontManager.fontName
                window.minSize = NSMakeSize(400, 300)
                window.contentViewController = {
                    let viewController = ShowViewController()
                    viewController.fontManager = fontManager
                    return viewController
                }()
                window.delegate = self
//                self.windows.append(window)
self.twindow = window
                window.center()
                window.makeKeyAndOrderFront(self)
            }
        }
    }

    func about(_ sender: NSMenuItem) {
        NSApp.orderFrontStandardAboutPanel(self)
    }

    func quit(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowShouldClose(_ sender: Any) -> Bool {
        if let window = sender as? NSWindow, let index = windows.index(of: window) {
//            windows.remove(at: index)
        }
        return true
    }
}
