//
//  ViewController.swift
//  HostsManager
//
//  Created by wenyou on 2016/12/23.
//  Copyright © 2016年 wenyou. All rights reserved.
//

import Cocoa

class FontViewController: NSViewController {
    static let size = NSMakeSize(800, 500)
    let margin: CGFloat = 20
    var cssFilePath: String!
    var characterInfos: [CharacterInfo]!
    var scrollView: FontScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = CGColor.white
        view.frame = NSRect(origin: NSPoint.zero, size: FontViewController.size)

        scrollView = FontScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.setTableData(characterInfos)
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        NSApp.mainWindow?.title = "Font Name: \(IconTool.sharedInstance.nowFontName!)"
    }

    override var representedObject: Any? {
        didSet {
        }
    }

    override func loadView() {
        view = NSView()
    }
}
