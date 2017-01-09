//
//  FileSelectedViewController.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/9.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa
import SnapKit


typealias SimpleBlockNoneParameter = () -> Void
typealias SimpleBlock = (_ data: AnyObject) -> Void
typealias FileSelectBlock = (_ ttfFilePath: String, _ cssFilePath: String) -> Void

class FileSelectedViewController: NSViewController, NSTextFieldDelegate {
    let size = NSMakeSize(600, 150)
    let margin: CGFloat = 20

    var submitButton: NSButton!
    var ttfTextField: NSTextField!
    var cssTextField: NSTextField!
    var nextWindowAction: FileSelectBlock?

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.frame = NSRect(origin: NSPoint.zero, size: size)

        let ttfButton = NSButton(title: ".ttf file", target: self, action: #selector(FileSelectedViewController.ttfButtonClicked(_:)))
        view.addSubview(ttfButton)

        let cssButton = NSButton(title: ".css file", target: self, action: #selector(FileSelectedViewController.cssButtonClicked(_:)))
        view.addSubview(cssButton)

        ttfTextField = NSTextField()
        ttfTextField.delegate = self
//        ttfTextField.isEditable = false
        view.addSubview(ttfTextField)

        cssTextField = NSTextField()
        cssTextField.delegate = self
        view.addSubview(cssTextField)

        submitButton = NSButton(title: "next", target: self, action: #selector(FileSelectedViewController.submitButtonClicked(_:)))
        submitButton.isEnabled = false
        view.addSubview(submitButton)

        ttfButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(margin * 1.5)
            make.left.equalToSuperview().offset(margin)
            make.width.equalTo(100)
            make.height.equalTo(margin)
        }

        ttfTextField.snp.makeConstraints { (make) in
            make.top.equalTo(ttfButton)
            make.height.equalTo(ttfButton)
            make.left.equalTo(ttfButton.snp.right).offset(margin)
            make.right.equalToSuperview().offset(0 - margin)
        }

        cssButton.snp.makeConstraints { (make) in
            make.top.equalTo(ttfButton.snp.bottom).offset(margin)
            make.left.equalTo(ttfButton)
            make.width.equalTo(ttfButton)
            make.height.equalTo(ttfButton)
        }

        cssTextField.snp.makeConstraints { (make) in
            make.top.equalTo(cssButton)
            make.height.equalTo(cssButton)
            make.left.equalTo(ttfTextField)
            make.right.equalTo(ttfTextField)
        }

        submitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(0 - margin)
            make.bottom.equalToSuperview().offset(0 - margin)
            make.width.equalTo(ttfButton)
            make.height.equalTo(ttfButton)
        }
    }

    override func viewDidAppear() {
        super.viewWillAppear()

        ttfTextField.stringValue = "/Users/wenyou/Desktop/font_p9brfmgxs1qbyb9/iconfont.ttf"
        cssTextField.stringValue = "/Users/wenyou/Desktop/font_p9brfmgxs1qbyb9/iconfont.css"
        setSubmitButtonStatus()
    }

    func ttfButtonClicked(_ sender: NSButton) {
        fileSelect("ttf")
    }

    func cssButtonClicked(_ sender: NSButton) {
        fileSelect("css")
    }

    func fileSelect(_ fileType: String) { // 文件选择器
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowedFileTypes = [fileType]
        panel.message = "select \(fileType) file"
        panel.begin { (handle) in
            if handle == NSFileHandlingPanelOKButton {
                if let path = panel.url {
                    switch fileType {
                    case "ttf":
                        self.ttfTextField.stringValue = path.path
                    case "css":
                        self.cssTextField.stringValue = path.path
                    default:
                        break
                    }
                    self.setSubmitButtonStatus()
                }
            }
        }
    }

    func setSubmitButtonStatus() { // 下一步按钮状态设置
        submitButton.isEnabled = ttfTextField.stringValue.characters.count > 0 && cssTextField.stringValue.characters.count > 0
    }

    func submitButtonClicked(_ sender: NSButton) { // 下一步
        if fileCheck("ttf") && fileCheck("css") && IconTool.sharedInstance.registFont(ttfTextField.stringValue) {
            if let eventAction = nextWindowAction {
                eventAction(ttfTextField.stringValue, cssTextField.stringValue)
            }
        }
    }

    func fileCheck(_ fileType: String) -> Bool { // 检查文件时候存在
        var pathString = ""
        switch fileType {
        case "ttf":
            pathString = ttfTextField.stringValue
        case "css":
            pathString = cssTextField.stringValue
        default:
            return false
        }
        if !FileManager.default.fileExists(atPath: pathString) {
            let alert = NSAlert()
            alert.messageText = "error"
            alert.informativeText = "file \(pathString) was not found"
            alert.alertStyle = .warning
            alert.beginSheetModal(for: NSApp.mainWindow!, completionHandler: nil)
//            alert.runModal() // 屏幕中间弹出
            return false
        }
        return true
    }

    // MARK: - NSTextFieldDelegate
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        setSubmitButtonStatus()
        return true
    }
}
