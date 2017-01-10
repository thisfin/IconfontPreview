//
//  FontScrollView.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/8.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

class FontScrollView: NSScrollView, NSTableViewDataSource, NSTableViewDelegate {
    private let columnSize = 20
    private let rowHeight: CGFloat = 30
    private let tableViewDragTypeName = "DragTypeName"
    private var tableView: NSTableView!
    var datas: [CharacterInfo]!

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
            column.width = ViewController.size.width / CGFloat(columnSize)
            column.resizingMask = .autoresizingMask
            column.title = String(i)
            tableView.addTableColumn(column)
        }
    }

    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return datas != nil ? (datas.count - 1) / columnSize + 1 : 0
    }

    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation { // 拖拽
        return .every
    }

    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        pboard.declareTypes([tableViewDragTypeName], owner: self)
        pboard.setData(data, forType: tableViewDragTypeName)
        return true
    }

    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        let pboard = info.draggingPasteboard()
        let rowData = pboard.data(forType: tableViewDragTypeName)
        let rowIndexs: NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! NSIndexSet
        let dragRow = rowIndexs.firstIndex

        if datas.count > 1 && dragRow != row { // 数据重新排列
            datas.insert(datas[dragRow], at: row)
            datas.remove(at: dragRow + (dragRow > row ? 1 : 0))
            tableView.noteNumberOfRowsChanged()
            tableView.reloadData()
        }
        return true
    }

    //    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    //        return datas[row]
    //    }

    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let identifier = tableColumn?.identifier {
            if ((row * columnSize + Int(identifier)!) < datas.count) {
                let textField = NSTextField()
                textField.font = IconTool.fontOfSize(40)
                //                textField.textColor = NSColor.colorWithHexValue(0x333333)
                textField.isEditable = false
                textField.isBordered = false
                textField.isBezeled = false
                textField.drawsBackground = false
                textField.isSelectable = false
                textField.backgroundColor = NSColor.clear
                textField.alignment = NSTextAlignment.center
                textField.autoresizingMask = .viewWidthSizable
                textField.maximumNumberOfLines = 1

                let charCode = UInt32(datas[row * columnSize + Int(identifier)!].code, radix: 16) // unicode转string
                let unicode = UnicodeScalar(charCode!)
                let str = String.init(unicode!)
                textField.stringValue = str

                return {
                    let view = NSView(frame: NSRect(origin: NSPoint.zero, size: NSMakeSize((tableColumn?.width)!, rowHeight)))
                    view.addSubview(textField)
                    textField.snp.makeConstraints({ (make) in
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
        return ViewController.size.width / CGFloat(columnSize)
    }

    func selectionShouldChange(in tableView: NSTableView) -> Bool {
        return true
    }

    // MARK: - private
    func doubleClicked(_ sender: NSTableView) { // 双击编辑
        let row: Int = sender.clickedRow
        let column: Int = sender.clickedColumn

        if row >= 0 && column >= 0 {
            if let v = sender.view(atColumn: column, row: row, makeIfNecessary: false) {
                v.subviews.filter({ (t) -> Bool in
                    t is NSTextField
                }).forEach({ (t) in
                    (t as! NSTextField).isEditable = true
                    self.window?.makeFirstResponder(t)
                })
            }
        }
    }

    func checkBoxClicked(_ sender: NSButton) {

    }

    func textFieldClicked(_ sender: NSTextField) {
        NSLog("textfield")
    }
    
    func setTableData(_ datas: [CharacterInfo]) {
        self.datas = datas
        tableView.reloadData()
    }
}
