//
//  FontManager.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/26.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class FontManager {
    var fontName: String
    var characterInfos = [CharacterInfo]()

    init?(url: URL) {
        guard let data = NSData(contentsOf: url), let cgDataProvider = CGDataProvider(data: data) else {
            return nil
        }

        let cgFont = CGFont(cgDataProvider)
        guard let fullName = cgFont.fullName else {
            return nil
        }
        fontName = fullName as String

        // 字体注册
        var cfError: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &cfError) {
            if let error = cfError {
                let errorDescription: CFString = CFErrorCopyDescription(error.takeUnretainedValue())
                NSLog("Failed to load font: \(errorDescription as String)")
                let alert = NSAlert()
                alert.messageText = "error"
                alert.informativeText = "Failed to load font: \(errorDescription as String)"
                alert.alertStyle = .warning
                alert.runModal()
                error.release()
            }
            return nil
        }

        // 字体解析
        let ctFont: CTFont = CTFontCreateWithGraphicsFont(cgFont, 0, nil, nil) // size 默认12
        let cfCharacterSet: CFCharacterSet = CTFontCopyCharacterSet(ctFont)
        let characterSet: CharacterSet = cfCharacterSet as CharacterSet
        let uniChars: [UniChar] = characterSet.allCharacters().map { (character) -> UniChar in
            return UniChar(character.unicodeScalarCodePoint())
        }
        uniChars.forEach { (uniChar) in // 字符遍历
            var cgGlyph: CGGlyph = 0
            let umpCGGlyph: UnsafeMutablePointer<CGGlyph> = withUnsafeMutablePointer(to: &cgGlyph, {$0})
            var temp = uniChar
            let upUniChar: UnsafePointer<UniChar> = withUnsafePointer(to: &temp, {$0})
            _ = CTFontGetGlyphsForCharacters(ctFont, upUniChar, umpCGGlyph, MemoryLayout<CGGlyph>.size + MemoryLayout<UniChar>.size) // 根据字符取 glyph
            if let _ = CTFontCreatePathForGlyph(ctFont, cgGlyph, nil) { // 通过 path 来过滤空白的字符
                let code: String = String(format: "%0x", uniChar)
                if let name: CFString = cgFont.name(for: cgGlyph) {
                    characterInfos.append(CharacterInfo(name: (name as NSString) as String, code: code))
                }
            }
        }
    }

    func fontOfSize(_ fontSize: CGFloat) -> NSFont {
        if let font = NSFont(name: fontName, size: fontSize) {
            return font
        }
        return NSFont.systemFont(ofSize: fontSize)
    }
}
