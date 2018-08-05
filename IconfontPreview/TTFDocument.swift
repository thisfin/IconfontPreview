//
//  TTFDocument.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/29.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit
import Then

class TTFDocument: NSDocument {
    private var tempFontManager: FontManager?

    override func makeWindowControllers() {
        guard let fontManager = tempFontManager else {
            return
        }

        let window = NSWindow(contentRect: .zero, styleMask: [.closable, .resizable, .miniaturizable, .titled], backing: .buffered, defer: false).then {
            $0.minSize = NSMakeSize(400, 300)
            $0.isRestorable = false
            $0.contentViewController = ShowViewController().then {
                $0.fontManager = fontManager
            }
            $0.center()
        }

        addWindowController(WindowController(window: window).then {
            $0.titleName = fontManager.fontName
        })
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
