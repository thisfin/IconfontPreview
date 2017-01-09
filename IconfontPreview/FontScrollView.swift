//
//  FontScrollView.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/8.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa

//class FontScrollView: NSScrollView, NSTableViewDataSource, NSTableViewDelegate {
//    private let columnSize = 20
//    private let rowHeight: CGFloat = 30
//    private let tableViewDragTypeName = "DragTypeName"
//    private var tableView: NSTableView!
//    var datas: [Host]!
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//
//        hasVerticalScroller = true
//
//        initSubview()
//    }
//
//    func initSubview() {
//        tableView = NSTableView()
//        tableView.dataSource = self
//        tableView.delegate = self
//        contentView.documentView = tableView
//
//        for i in 0..<columnSize {
//            let column = NSTableColumn(identifier: String(format: "column%ld", i))
//            column.width = ViewController.size.width / CGFloat(columnSize)
//            column.resizingMask = .autoresizingMask
//            tableView.addTableColumn(column)
//        }
//    }
//
//    // MARK: - NSTableViewDataSource
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return datas != nil ? datas.count : 0
//    }
//
//    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation { // 拖拽
//        return .every
//    }
//
//    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
//        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
//        pboard.declareTypes([tableViewDragTypeName], owner: self)
//        pboard.setData(data, forType: tableViewDragTypeName)
//        return true
//    }
//
//    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
//        let pboard = info.draggingPasteboard()
//        let rowData = pboard.data(forType: tableViewDragTypeName)
//        let rowIndexs: NSIndexSet = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! NSIndexSet
//        let dragRow = rowIndexs.firstIndex
//
//        if datas.count > 1 && dragRow != row { // 数据重新排列
//            datas.insert(datas[dragRow], at: row)
//            datas.remove(at: dragRow + (dragRow > row ? 1 : 0))
//            tableView.noteNumberOfRowsChanged()
//            tableView.reloadData()
//        }
//        return true
//    }
//
//    //    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//    //        return datas[row]
//    //    }
//
//    // MARK: - NSTableViewDelegate
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        let width: CGFloat = (tableColumn?.width)!
//        let height: CGFloat = rowHeight
//
//        if let identifier = tableColumn?.identifier {
//            var resultSubView: NSView?
//            switch identifier {
//            case "column0":
//                let checkBox = NSButton(checkboxWithTitle: " ", target: self, action: #selector(HostScrollView.checkBoxClicked(_:)))
//                checkBox.state = datas[row].selected ? 1 : 0
//                checkBox.frame.origin = NSMakePoint((width - checkBox.frame.width) / 2 + 5, (height - checkBox.frame.height) / 2)
//                resultSubView = checkBox
//            default:
//                let textFieldHeight: CGFloat = 20
//                let padding: CGFloat = (height - textFieldHeight) / 2
//                let textField = NSTextField(frame: NSMakeRect(padding, padding, width - padding * 2, textFieldHeight))
//                textField.font = NSFont.systemFont(ofSize: 14)
//                textField.textColor = NSColor.colorWithHexValue(0x333333)
//                textField.isEditable = false
//                textField.isBordered = false
//                textField.isBezeled = false
//                textField.drawsBackground = false
//                textField.isSelectable = true
//                textField.backgroundColor = NSColor.clear
//                textField.alignment = NSTextAlignment.right
//                textField.autoresizingMask = .viewWidthSizable
//                textField.maximumNumberOfLines = 1
//                switch identifier {
//                case "column1":
//                    textField.stringValue = datas[row].ip!
//                    textField.placeholderString = "ip地址 非空"
//                case "column2":
//                    textField.stringValue = datas[row].domain!
//                    textField.placeholderString = "域名 非空"
//                case "column3":
//                    textField.stringValue = datas[row].desc ?? ""
//                default:
//                    break
//                }
//                resultSubView = textField
//            }
//            return {
//                let view = NSView(frame: NSRect(origin: NSPoint.zero, size: NSMakeSize(width, height)))
//                view.addSubview(resultSubView!)
//                return view
//                }()
//        }
//        return nil
//    }
//
//    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) { // 背景色
////        rowView.backgroundColor = row % 2 == 0 ? Constants.colorTableBackgroundLight : Constants.colorTableBackground
//    }
//
//    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat { // 行高
//        return ViewController.size.width / columnSize
//    }
//
//    func selectionShouldChange(in tableView: NSTableView) -> Bool {
//        return true
//    }
//
//    // MARK: - private
//    func doubleClicked(_ sender: NSTableView) { // 双击编辑
//        let row: Int = sender.clickedRow
//        let column: Int = sender.clickedColumn
//
//        if row >= 0 && column >= 0 {
//            if let v = sender.view(atColumn: column, row: row, makeIfNecessary: false) {
//                v.subviews.filter({ (t) -> Bool in
//                    t is NSTextField
//                }).forEach({ (t) in
//                    (t as! NSTextField).isEditable = true
//                    self.window?.makeFirstResponder(t)
//                })
//            }
//        }
//    }
//
//    func checkBoxClicked(_ sender: NSButton) {
//
//    }
//
//    func textFieldClicked(_ sender: NSTextField) {
//        NSLog("textfield")
//    }
//    
//    func setTableData(_ datas: [Host]) {
//        self.datas = datas
//        tableView.reloadData()
//    }
//}
