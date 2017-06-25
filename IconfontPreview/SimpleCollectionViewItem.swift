//
//  SimpleCollectionViewItem.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/26.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit
import SnapKit
import WYKit

class SimpleCollectionViewItem: NSCollectionViewItem {
    let titleField = NSTextField()

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.isEditable = false
        titleField.isSelectable = true
        titleField.isBordered = false
        titleField.alignment = .center
        titleField.backgroundColor = .clear
        titleField.font = IconTool.fontOfSize(32)
        view.addSubview(titleField)
        titleField.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    func configData(characterInfo: CharacterInfo) {
        if let charCode = UInt32(characterInfo.code, radix: 16), let unicode = UnicodeScalar(charCode) {
            titleField.stringValue = String(unicode)
        } else {
            titleField.stringValue = ""
        }
    }
}
