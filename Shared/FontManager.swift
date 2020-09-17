//
//  FontManager.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/6/26.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

import SwiftUI

class FontManager {
    var fontName: String
    var characterInfos = [CharacterInfo]()

    func fontOfSize(_ fontSize: CGFloat) -> Font {
        return Font.custom(fontName, size: fontSize)
    }

    init?(data: Data) {
        guard let cgDataProvider = CGDataProvider(data: data as NSData),
            let cgFont = CGFont(cgDataProvider),
            let fullName = cgFont.fullName as String?,
            let scriptName = cgFont.postScriptName as String? else {
            return nil
        }
        fontName = fullName

        // 已经注册过的字体取消注册, 在下面重新注册
        #if os(macOS)
            let fonts = NSFontManager.shared.availableFonts()
        #else
            let fonts = UIFont.familyNames.flatMap { (familyName) -> [String] in
                UIFont.fontNames(forFamilyName: familyName)
            }
        #endif
        if fonts.contains(scriptName) {
            CTFontManagerUnregisterGraphicsFont(cgFont, nil)
        }

        // 字体注册
        var cfError: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &cfError) {
            if let error = cfError {
                let errorDescription: CFString = CFErrorCopyDescription(error.takeUnretainedValue())
                NSLog("Failed to load font: \(errorDescription as String)")
//                let alert = NSAlert()
//                alert.messageText = "error"
//                alert.informativeText = "Failed to load font: \(errorDescription as String)"
//                alert.alertStyle = .warning
//                alert.runModal()
                error.release()
            }
//            return nil
        }

        // 字体解析
        let ctFont: CTFont = CTFontCreateWithGraphicsFont(cgFont, 0, nil, nil) // size 默认12
        let cfCharacterSet: CFCharacterSet = CTFontCopyCharacterSet(ctFont)
        let characterSet: CharacterSet = cfCharacterSet as CharacterSet

        // UTF-32
        let uint32s: [UInt32] = characterSet.allCharacters().map { (character) -> UInt32 in
            character.unicodeScalarCodePoint()
        }
        uint32s.forEach { uint32 in
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
}
