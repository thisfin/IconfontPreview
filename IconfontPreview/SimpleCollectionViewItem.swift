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
        view.addSubview(titleField)
        titleField.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    override func mouseDown(with event: NSEvent) {
        NSMenu.popUpContextMenu(NSMenu().then {
            $0.addItem(withTitle: "copy unicode to pasteboard", action: #selector(SimpleCollectionViewItem.copyClicked(_:)), keyEquivalent: "")
            $0.addItem(withTitle: "copy fontName to pasteboard", action: #selector(SimpleCollectionViewItem.copyClicked1(_:)), keyEquivalent: "")
            $0.addItem(.separator())
            $0.addItem(withTitle: "font: \(ci.fontName)", action: nil, keyEquivalent: "")
            $0.addItem(withTitle: "name: \(ci.name)", action: nil, keyEquivalent: "")
            $0.addItem(withTitle: "code: \(ci.code)", action: nil, keyEquivalent: "")
        }, with: event, for: titleField)
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
}

@objc extension SimpleCollectionViewItem {
    private func copyClicked(_ sender: NSMenuItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(ci.code, forType: .string)
    }

    private func copyClicked1(_ sender: NSMenuItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(ci.fontName, forType: .string)
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
