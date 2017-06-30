//
//  SimpleCollectionViewItem.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/26.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit
import SnapKit

class SimpleCollectionViewItem: NSCollectionViewItem {
    private let titleField = NSTextField()
    private var ci: CharacterInfo!
    var fontManager: FontManager!


    override func loadView() {
        view = EventView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.isEditable = false
        titleField.isSelectable = false
        titleField.isBordered = false
        titleField.alignment = .center
        titleField.backgroundColor = .clear
        view.addSubview(titleField)
        titleField.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    override func mouseDown(with event: NSEvent) {
        NSMenu.popUpContextMenu({
            let menu = NSMenu()
            menu.addItem(withTitle: "copy unicode to pasteboard", action: #selector(SimpleCollectionViewItem.copyClicked(_:)), keyEquivalent: "")
            menu.addItem(.separator())
            menu.addItem(withTitle: "name: \(ci.name)", action: nil, keyEquivalent: "")
            menu.addItem(withTitle: "code: \(ci.code)", action: nil, keyEquivalent: "")
            return menu
        }(), with: event, for: titleField)
    }

    func configData(characterInfo: CharacterInfo) {
        titleField.font = fontManager.fontOfSize(32)
        if let charCode = UInt32(characterInfo.code, radix: 16), let unicode = UnicodeScalar(charCode) {
            titleField.stringValue = String(unicode)
        } else {
            titleField.stringValue = ""
        }
        ci = characterInfo
    }

    func copyClicked(_ sender: NSMenuItem) {
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSStringPboardType], owner: self)
        pasteboard.setString(ci.code, forType: NSPasteboardTypeString)
    }
}

class EventView: NSView { // 禁止 subview 上的事件
    override func hitTest(_ point: NSPoint) -> NSView? {
        if NSPointInRect(point, convert(self.bounds, to: superview)) {
            return self
        }
        return nil
    }
}
