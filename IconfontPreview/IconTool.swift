//
//  IconTools.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/9.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Cocoa
import CoreText

class IconTool: NSObject {
    private static let selfInstance = IconTool()

    private var fonts: [String : String] = [:] // key->path, value->name
    var nowFontName: String!

    // 单例范例
    public static var sharedInstance: IconTool {
        return selfInstance
    }

    override private init() {
        super.init()
    }

    func registFont(_ path: String) -> Bool {
        if fonts.keys.contains(path) {
            nowFontName = fonts[path]
            return true
        }

        var data: NSData?
        FilePermissions.sharedInstance.handleFile(fileType: "ttf", newPath: path) { (url) in
            data = NSData.init(contentsOf: url)
        }

        if let dynamicFontData = data {
            let dataProvider: CGDataProvider? = CGDataProvider(data: dynamicFontData)
            let font: CGFont? = CGFont(dataProvider!)
            var error: Unmanaged<CFError>? = nil

            nowFontName = (font?.fullName)! as String
            fonts[path] = nowFontName

            if !CTFontManagerRegisterGraphicsFont(font!, &error) {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                NSLog("Failed to load font: \(errorDescription as String)")
                let alert = NSAlert()
                alert.messageText = "error"
                alert.informativeText = "Failed to load font: \(errorDescription as String)"
                alert.alertStyle = .warning
                alert.beginSheetModal(for: NSApp.mainWindow!, completionHandler: nil)
                return false
            }
            error?.release()
            return true
        }
        return false
    }

    static func fontOfSize(_ fontSize: CGFloat) -> NSFont {
        if let fontName = IconTool.sharedInstance.nowFontName {
            if let font = NSFont(name: fontName, size: fontSize) {
                return font
            }
        }
        assert(false, "font couldn't be loaded")
        return NSFont()
    }
}
