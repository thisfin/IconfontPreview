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

        guard let cgFont = CGFont(cgDataProvider), let fullName = cgFont.fullName else {
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
        /*
         let uniChars: [UniChar] = characterSet.allCharacters().map { (character) -> UniChar in
         return UniChar(character.unicodeScalarCodePoint()) // uint32 溢出
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
         */
        // UTF-32
        let uint32s: [UInt32] = characterSet.allCharacters().map { (character) -> UInt32 in
            return character.unicodeScalarCodePoint()
        }
//        uint32s.forEach { (uint32) in // 字符遍历 这么写打包后会死循环, 我也不知道为什么
        for i in 0 ..< uint32s.count {
            let uint32 = uint32s[i]

            var cgGlyph: CGGlyph = 0
            let umpCGGlyph: UnsafeMutablePointer<CGGlyph> = withUnsafeMutablePointer(to: &cgGlyph, { $0 })
            var codePoint: [UniChar] = [
                UniChar(truncatingIfNeeded: uint32),
                UniChar(truncatingIfNeeded: uint32 >> 16),
            ]
            _ = CTFontGetGlyphsForCharacters(ctFont, &codePoint, umpCGGlyph, MemoryLayout<CGGlyph>.size + MemoryLayout<UniChar>.size) // 根据字符取 glyph
            if let _ = CTFontCreatePathForGlyph(ctFont, cgGlyph, nil) { // 通过 path 来过滤空白的字符
                let code: String = String(format: "%0x", uint32)
                if let name: CFString = cgFont.name(for: cgGlyph) {
                    characterInfos.append(CharacterInfo(name: (name as NSString) as String, code: code, fontName: fontName))
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
