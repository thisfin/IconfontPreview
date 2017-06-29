//
//  DocumentController.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/29.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class DocumentController: NSDocumentController {
    // 定制打开菜单 增加 message; 点击 cancel 且无活动文档时退出程序
    override func beginOpenPanel(_ openPanel: NSOpenPanel, forTypes inTypes: [String]?, completionHandler: @escaping (Int) -> Swift.Void) {
        openPanel.message = "please select .ttf file"
        super.beginOpenPanel(openPanel, forTypes: inTypes) { (type) in
            if type == NSModalResponseCancel && self.documents.count == 0 {
                NSApp.terminate(self)
            }
            completionHandler(type)
        }
    }
}
