//
//  FontScrollView.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/8.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

class FontScrollView: NSScrollView, NSTableViewDataSource, NSTableViewDelegate {
    private let columnSize = 16
    private var tableView: NSTableView!
    var datas: [CharacterInfo]!
    var nowCharacterInfo: CharacterInfo!
    var characterDict: [String : CharacterInfo] = [:]

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        hasVerticalScroller = true
        initSubview()
    }

    func initSubview() {
        tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.intercellSpacing = NSSize.zero
        tableView.headerView = nil
        contentView.documentView = tableView

        for i in 0..<columnSize {
            let column = NSTableColumn(identifier: "\(i)")
            column.width = FontViewController.size.width / CGFloat(columnSize)
            column.resizingMask = .autoresizingMask
            column.title = String(i)
            tableView.addTableColumn(column)
        }
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return datas != nil ? (datas.count - 1) / columnSize + 1 : 0
    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let identifier = tableColumn?.identifier {
            if ((row * columnSize + Int(identifier)!) < datas.count) {
                let characterInfo = datas[row * columnSize + Int(identifier)!]
                let charCode = UInt32(characterInfo.code, radix: 16) // unicode转string
                let unicode = UnicodeScalar(charCode!)
                let str = String.init(unicode!)
                characterDict[str] = characterInfo
                let button = NSButton.init(title: str, target: self, action: #selector(FontScrollView.iconButtonClicked(_:)))
                button.font = IconTool.fontOfSize(32)
                button.isBordered = false
                button.setButtonType(.momentaryPushIn)

                return {
                    let view = NSView(frame: NSRect(origin: NSPoint.zero, size: NSMakeSize((tableColumn?.width)!, (tableColumn?.width)!)))
                    view.addSubview(button)
                    button.snp.makeConstraints({ (make) in
                        make.edges.equalToSuperview()
                    })

                    return view
                    }()
            }
        }
        return nil
    }

    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) { // 背景色
//        rowView.backgroundColor = row % 2 == 0 ? Constants.colorTableBackgroundLight : Constants.colorTableBackground
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat { // 行高
        return FontViewController.size.width / CGFloat(columnSize)
    }

    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return false
    }

    func textFieldClicked(_ sender: NSTextField) {
        NSLog("textfield")
    }

    func iconButtonClicked(_ sender: NSButton) {
        nowCharacterInfo = characterDict[sender.title]
        if let event = NSApplication.shared().currentEvent {
            NSMenu.popUpContextMenu({
                let menu = NSMenu()
                menu.addItem({
                    let item = NSMenuItem()
                    item.title = "copy unicode to pasteboard"
                    item.target = self
                    item.action = #selector(FontScrollView.copyClicked(_:))
                    return item
                    }())
                menu.addItem(.separator())
                menu.addItem(withTitle: "name: \(self.nowCharacterInfo.name)", action: nil, keyEquivalent: "")
                menu.addItem(withTitle: "code: \(self.nowCharacterInfo.code)", action: nil, keyEquivalent: "")
                return menu
            }(), with: event, for: sender)
        }
    }

    func setTableData(_ datas: [CharacterInfo]) {
        self.datas = datas
        tableView.reloadData()
    }

    func copyClicked(_ sender: NSMenuItem) {
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSStringPboardType], owner: self)
        pasteboard.setString(nowCharacterInfo.code, forType: NSPasteboardTypeString)
    }
}
