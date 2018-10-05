//
//  DragView.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/29.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class DragView: NSView {
    private let fileTypes = ["ttf"]
    private let pasteboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType") // swift 3 NSFilenamesPboardType, 这地方这么改不一定对, 但是现在没问题

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        registerForDraggedTypes([pasteboardType])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation { // 根据文件类型做判断
        var isMatch = false
        if let paths = sender.draggingPasteboard.propertyList(forType: pasteboardType) as? [String] {
            paths.forEach({ (path) in
                if fileTypes.contains((path as NSString).pathExtension.lowercased()) {
                    isMatch = true
                    return
                }
            })
        }
        return isMatch ? sender.draggingSourceOperationMask : []
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool { // 循环创建
        if let paths = sender.draggingPasteboard.propertyList(forType: pasteboardType) as? [String] {
            paths.forEach({ (path) in
                if fileTypes.contains((path as NSString).pathExtension.lowercased()) {
                    NSDocumentController.shared.openDocument(withContentsOf: URL(fileURLWithPath: path), display: true, completionHandler: { (document, b, nil) in
                    })
                }
            })
        }
        return true
    }
}
