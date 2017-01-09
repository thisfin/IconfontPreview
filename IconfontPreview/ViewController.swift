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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        view.frame = NSRect(origin: NSPoint.zero, size: ViewController.size)

        let font = WYIconfont.fontOfSize(16)
        let f: CGFont = WYIconfont.f

        for i in 1..<font.numberOfGlyphs {
            NSLog("%ld", i)
            NSLog("%@", f.name(for: CGGlyph(i)) != nil ? (f.name(for: CGGlyph(i)) as! String) : "")
        }

        

        let fontRef: CTFont = CTFontCreateWithName(WYIconfont.p as NSString, 0.0, nil)
//        let charRef: CFCharacterSet = CTFontCopyCharacterSet(fontRef)
        let a: NSCharacterSet = CTFontCopyCharacterSet(fontRef)
        for i in 1..<font.numberOfGlyphs {
            if a.characterIsMember(unichar(i)) {
                NSLog("%c", unichar(i))
            } else {
                NSLog(">>>%ld", i)
            }
        }
//        NSCharacterSet *characterset = [NSCharacterSet alphanumericCharacterSet];
//        unichar idx;
//        for( idx = 0; idx < 256; idx++ )
//        {
//            if ([characterset characterIsMember: idx])
//            {
//                if ( isprint(idx) ) {
//                    NSLog(@"%c",idx);
//                }
//                else {
//                    printf( "%02x ", idx);
//                }
//            }
//        }

//        NSLog("%ld", aaaa.count)


//        NSUInteger glyphCount = [_font numberOfGlyphs];
//        _glyphPathArray = [[NSMutableArray alloc] initWithCapacity:glyphCount];
//
//        for (NSUInteger i=1; i<=glyphCount; i++) {
//            NSRect boundingRect = [_font boundingRectForGlyph:(NSGlyph)i];
//
//            if (!NSIsEmptyRect(boundingRect)) {
//
//                // convert glyph into bezier path
//                NSBezierPath *path = [[NSBezierPath alloc] init];
//                [path moveToPoint:NSMakePoint(-NSMidX(boundingRect), -NSMidY(boundingRect))];
//                [path appendBezierPathWithGlyph:(NSGlyph)i inFont:_font];
//                [_glyphPathArray addObject:path];
//            }
//        }
//
//        let view1 = NSView()
//        view1.wantsLayer = true
//        view1.layer?.backgroundColor = NSColor.red.cgColor
//        view.addSubview(view1)
//
//        let view2 = NSView()
//        view2.wantsLayer = true
//        view2.layer?.backgroundColor = NSColor.blue.cgColor
//        view.addSubview(view2)
//
//        let view3 = NSView()
//        view3.wantsLayer = true
//        view3.layer?.backgroundColor = NSColor.yellow.cgColor
//        view.addSubview(view3)
//
//        let view4 = NSView()
//        view4.wantsLayer = true
//        view4.layer?.backgroundColor = NSColor.green.cgColor
//        view.addSubview(view4)
//
//        view1.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(margin)
//            make.top.equalToSuperview().offset(margin)
//            make.height.equalTo(100)
//        }
//
//        view2.snp.makeConstraints { (make) in
//            make.left.equalTo(view1)
//            make.width.equalTo(view1)
//            make.top.equalTo(view1.snp.bottom).offset(margin)
//            make.bottom.equalToSuperview().offset(0 - margin)
//        }
//
//        view3.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(0 - margin)
//            make.top.equalTo(view1)
//            make.width.equalTo(view1).multipliedBy(2)
//            make.left.equalTo(view1.snp.right).offset(margin)
//            make.bottom.equalTo(view1)
//        }
//
//        view4.snp.makeConstraints { (make) in
//            make.width.equalTo(view3)
//            make.right.equalTo(view3)
//            make.top.equalTo(view2)
//            make.bottom.equalTo(view2)
//        }



//        var fontName = "Zapfino"
//        var fUseLigatures = false
//
//
//        var stringAttributes: [String: AnyObject] = [:]
//        stringAttributes[NSFontAttributeName] = font
//        stringAttributes[NSLigatureAttributeName] = NSNumber.init(value: 0)
//
//        let string = NSAttributedString(
//            string:"This is \(fontName)!",
//            attributes: stringAttributes)
//        let line = CTLineCreateWithAttributedString(string) // CTLine
//
//        let runs = CTLineGetGlyphRuns(line) // CTRun[]
//        let nsRuns:Array<AnyObject> = runs as Array<AnyObject>
//        assert(nsRuns.count == 1)
//
//        let run = nsRuns[0] as! CTRun
//
//        let glyphCount: Int = CTRunGetGlyphCount(run)
//        NSLog("String: %@", string.string)
//        NSLog("StrLen: %ld, Count Of Glyphs: %ld", string.string.lengthOfBytes(using: .utf8), Int(glyphCount))
//
//        let clusters = UnsafeMutablePointer<CFIndex>.allocate(capacity: glyphCount)
//        CTRunGetStringIndices(run, CFRange(location:0, length:glyphCount), clusters)
//        
//        for idx in 0..<glyphCount {
//            let idxString = clusters[idx]
//            NSLog("Glyph %ld maps to String %@", Int(idx), idxString)
//        }
    }

    override var representedObject: Any? {
        didSet {
        }
    }

    override func loadView() {
        view = NSView()
    }
}
