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
    static let sharedInstance = IconTool()

    var datas = [CharacterInfo]()

    override private init() {
        super.init()
    }

    private var fonts: [String : String] = [:] // key->path, value->name
    var nowFontName: String!

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
            var error: Unmanaged<CFError>?


//            if let array = font?.tableTags as? NSArray {
//                NSLog("\(array.count)")
//                let a = array[0]
//            }
//            CGFontCopyGlyphNameForGlyph()
//            CTFontCopyGraphicsFont()

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

            test(cgFont: font!)


            return true
        }
        return false
    }

    func test(cgFont: CGFont) {
        let ctFont: CTFont = CTFontCreateWithGraphicsFont(cgFont, 0, nil, nil) // size 默认12
        let cfCharacterSet: CFCharacterSet = CTFontCopyCharacterSet(ctFont)
        let characterSet: CharacterSet = cfCharacterSet as CharacterSet

        let unichars: [UniChar] = characterSet.allCharacters().map { (character) -> UniChar in
            return UniChar(character.unicodeScalarCodePoint())
        }

        var i = 0
        unichars.forEach { (unichar) in
            var cgGlyph: CGGlyph = 0
            let umpCGGlyph: UnsafeMutablePointer<CGGlyph> = withUnsafeMutablePointer(to: &cgGlyph, {$0})
            var temp = unichar
            let upUnichar: UnsafePointer<UniChar> = withUnsafePointer(to: &temp, {$0})
            let result = CTFontGetGlyphsForCharacters(ctFont, upUnichar, umpCGGlyph, MemoryLayout<CGGlyph>.size)


            let upCGGlyph: UnsafePointer<CGGlyph> = withUnsafePointer(to: &umpCGGlyph.pointee, {$0})
            let rect = CTFontGetBoundingRectsForGlyphs(ctFont, .default, upCGGlyph, nil, MemoryLayout<CGGlyph>.size + MemoryLayout<CGRect>.size)

            if let path = CTFontCreatePathForGlyph(ctFont, cgGlyph, nil) {

            if !rect.isEmpty {
                let c: String = String(format: "%0x", unichar)// "\(unichar)"
                let name: CFString = cgFont.name(for: cgGlyph)!
                datas.append(CharacterInfo(name: (name as NSString) as String, code: c))
                NSLog("\(result) \(umpCGGlyph.pointee) \(rect) \(path) \(name)")
                i += 1
            }
            }
        }

NSLog("\(i)")

        var j = 0
        if let font = NSFont(name: nowFontName, size: 10) {
            for m in 1 ... font.numberOfGlyphs {
                let rect = font.boundingRect(forGlyph: NSGlyph(m))
                if !rect.isEmpty {
                    j += 1
                }
            }
            NSLog("\(j) \(font.coveredCharacterSet.allCharacters().count)")
        }



        /*!
         @function   CTFontGetBoundingRectsForGlyphs
         @abstract   Calculates the bounding rects for an array of glyphs and returns the overall bounding rect for the run.

         @param      font
         The font reference.

         @param      orientation
         The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.

         @param      glyphs
         An array of count number of glyphs.

         @param      boundingRects
         An array of count number of CGRects to receive the computed glyph rects. Can be NULL, in which case only the overall bounding rect is calculated.

         @param      count
         The capacity of the glyphs and boundingRects buffers.

         @result     This function returns the overall bounding rectangle for an array or run of glyphs. The bounding rects of the individual glyphs are returned through the boundingRects parameter. These are the design metrics from the font transformed in font space.
         */
//        @available(OSX 10.5, *)
//        public func CTFontGetBoundingRectsForGlyphs(_ font: CTFont, _ orientation: CTFontOrientation, _ glyphs: UnsafePointer<CGGlyph>!, _ boundingRects: UnsafeMutablePointer<CGRect>?, _ count: CFIndex) -> CGRect




        /*
        var count: CFIndex = 0

        var temp: CGGlyph = 0
        let cgGlyphs: UnsafeMutablePointer<CGGlyph> = withUnsafeMutablePointer(to: &temp, {$0})
        let uc: UnsafePointer<UniChar> = withUnsafePointer(to: &(unichars[20]), {$0})

        var bbb = CTFontGetGlyphsForCharacters(ctFont, uc, cgGlyphs, count)



//        let theCat = "Cat!🐱"
//
//        for char in theCat.utf8 {
//            print("\(char) ", terminator: "") //Code Unit of each grapheme cluster for the UFT8 encoding
//        }



        let a: NSCharacterSet = set
        let b: CharacterSet = a as CharacterSet
        let nsFont = NSFont(name: nowFontName, size: 10)
        
        b.allCharacters().forEach { (character) in
            let gl = nsFont?.glyph(withName: String.init(character))

            NSLog("\(character) \(character.description) \(character.unicodeScalarCodePoint()) \(Int(gl!))")
        }
//CTLineGetGlyphRuns()
//        CTFontGetGlyphsForCharacters()

        for i in 1 ... cgFont.numberOfGlyphs {
            let ctFlyphInfoRef = CTGlyphInfoCreateWithGlyph(CGGlyph(i), ctFont, "c" as CFString)
            if let name = CTGlyphInfoGetGlyphName(ctFlyphInfoRef) {
                NSLog((name as? String)!)
            } else {
                NSLog("\(i)")
            }
        }

//        for (CGGlyph i = 1; i < count + 1; i++)
//        {
//            CTGlyphInfoRef gi = CTGlyphInfoCreateWithGlyph(i, f, CFSTR("(c)"));
//            CFStringRef name = CTGlyphInfoGetGlyphName(gi);
//            CGFontIndex idx = CTGlyphInfoGetCharacterIdentifier(gi);
//
//            printf("Glyph: %4hu, idx: %4hu ", i, idx);
//            CFShow(name);
//            printf("\n");
//            
//        }
//        CTFontCreateWithGraphicsFont(
//CTGlyphInfoCreateWithGlyph()

//        var count = 0
//        if let font = NSFont(name: nowFontName, size: 10) {
//
//            for i in 1 ... font.numberOfGlyphs {
//                let boundingRect = font.boundingRect(forGlyph: NSGlyph(i))
//                if !boundingRect.isEmpty {
//                    count += 1
//                }
//                NSLog("\(boundingRect)")
//            }
//        }
//        NSLog("\(count)")

        //
        //            let a = NSNullGlyph
        //            let nsFont: NSFont = font as NSFont
        //            nsFont.gl
        //            nsFont.boundingRect(forGlyph: NSGlyph)
        //
        //
        //
        //
        //            NSUInteger glyphCount = [_font numberOfGlyphs];
        //            _glyphPathArray = [[NSMutableArray alloc] initWithCapacity:glyphCount];
        //
        //            for (NSUInteger i=1; i<=glyphCount; i++) {
        //                NSRect boundingRect = [_font boundingRectForGlyph:(NSGlyph)i];
        //
        //                if (!NSIsEmptyRect(boundingRect)) {
        //
        //                    // convert glyph into bezier path
        //                    NSBezierPath *path = [[NSBezierPath alloc] init];
        //                    [path moveToPoint:NSMakePoint(-NSMidX(boundingRect), -NSMidY(boundingRect))];
        //                    [path appendBezierPathWithGlyph:(NSGlyph)i inFont:_font];
        //                    [_glyphPathArray addObject:path];
        //                }
        //            }
        
*/
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
