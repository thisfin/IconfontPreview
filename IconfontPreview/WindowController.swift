//
//  WindowController.swift
//  IconfontPreview
//
//  Created by wenyou on 2018/8/5.
//  Copyright © 2018 wenyou. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    var titleName: String?

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return titleName ?? ""
    }
}
