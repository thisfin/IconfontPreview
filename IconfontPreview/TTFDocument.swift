//
//  TTFDocument.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/29.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class TTFDocument: NSDocument {
    private var tempFontManager: FontManager?

    override func makeWindowControllers() {
        guard let fontManager = tempFontManager else {
            return
        }

        let window = NSWindow(contentRect: CGRect(origin: .zero, size: NSMakeSize(800, 600)), styleMask: [.closable, .resizable, .miniaturizable, .titled], backing: .buffered, defer: false)
        // window.title = fontManager.fontName // 无效
        window.minSize = NSMakeSize(400, 300)
        window.isRestorable = false
        window.contentViewController = {
            let viewController = ShowViewController()
            viewController.fontManager = fontManager
            return viewController
        }()
        window.center()

        let windowController = NSWindowController(window: window)
        addWindowController(windowController)
        displayName = fontManager.fontName
    }

    // 写文件时用
    override func data(ofType typeName: String) throws -> Data {
        return Data()
    }

    // 读文件
    override func read(from url: URL, ofType typeName: String) throws {
        tempFontManager = FontManager(url: url)
    }
}
