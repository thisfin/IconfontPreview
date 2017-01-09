//
//  ViewController.swift
//  HostsManager
//
//  Created by wenyou on 2016/12/23.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    static let size = NSMakeSize(1000, 600)
    let margin: CGFloat = 20
    var cssFilePath: String!
    var characters: [CharacterInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        view.frame = NSRect(origin: NSPoint.zero, size: ViewController.size)

        // 字符串解析
        parseCss()
        // table
    }

    override var representedObject: Any? {
        didSet {
        }
    }

    override func loadView() {
        view = NSView()
    }

    func parseCss() {
        do {
            var fontName: NSString?

            let content = try String.init(contentsOfFile: cssFilePath) // 解析字体名
            let scanner = Scanner(string: content)
            scanner.scanUpTo("@font-face", into: nil)
            scanner.scanLocation += "@font-face".characters.count
            scanner.scanUpTo("font-family", into: nil)
            scanner.scanLocation += "font-family".characters.count
            scanner.scanUpTo("\"", into: nil)
            scanner.scanLocation += "\"".characters.count
            scanner.scanUpTo("\"", into: &fontName)

            if fontName as? String != IconTool.sharedInstance.nowFontName { //TODO: 异常判断
                let alert = NSAlert()
                alert.messageText = "error"
                alert.informativeText = "ttf font and css font not for same"
                alert.alertStyle = .warning
                alert.beginSheetModal(for: NSApp.mainWindow!, completionHandler: nil)
            }

            let regex = try! NSRegularExpression(pattern:"\\..*:before.*content:.*\".*\"", options: []) // 解析字体
            regex.enumerateMatches(in: content, options: [], range: NSMakeRange(0, content.characters.count)) { result, flags, stop in
                if let range = result?.range {
                    let str = (content as NSString).substring(with: range)
                    let scan = Scanner(string: str)
                    var name: NSString?
                    var code: NSString?
                    scan.scanUpTo(".", into: nil)
                    scan.scanLocation += ".".characters.count
                    scan.scanUpTo(":before", into: &name)
                    scan.scanUpTo("\"", into: nil)
                    scan.scanLocation += "\"".characters.count
                    scan.scanUpTo("\"", into: &code)

                    if let name1 = name as String?, let code1 = code as String? {
                        let character = CharacterInfo(name: name1, code: code1)
                        characters.append(character)
                    }
                }
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "error"
            alert.informativeText = "css file parse error"
            alert.alertStyle = .warning
            alert.beginSheetModal(for: NSApp.mainWindow!, completionHandler: nil)
        }

//        if let content = try? String.init(contentsOfFile: cssFilePath) { // 两种拆包方法
//            NSLog(content)
//        }
    }
}
