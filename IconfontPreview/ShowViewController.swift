//
//  ShowViewController.swift
//  IconfontPreview
//
//  Created by fin on 2017/6/26.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class ShowViewController: NSViewController {
    private var collectionView: NSCollectionView!
    var datas: [CharacterInfo]!

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        view.frame = NSRect(origin: .zero, size: NSMakeSize(800, 500))

        collectionView = NSCollectionView.init()
        collectionView.collectionViewLayout = NSCollectionViewFlowLayout()
        collectionView.register(SimpleCollectionViewItem.classForCoder(), forItemWithIdentifier: SimpleCollectionViewItem.className())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false

        let scrollView = NSScrollView()
        scrollView.backgroundColor = .red
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        scrollView.contentView.documentView = collectionView
        scrollView.documentView = collectionView
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
}

extension ShowViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: SimpleCollectionViewItem.className(), for: indexPath)
        if let item = collectionViewItem as? SimpleCollectionViewItem {
            item.configData(characterInfo: datas[indexPath.item])
        }
        return collectionViewItem
    }
}

extension ShowViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
//        if 0 > indexPaths.
//        nowCharacterInfo = characterDict[indexPaths.item]
//        if let event = NSApplication.shared().currentEvent {
//            NSMenu.popUpContextMenu({
//                let menu = NSMenu()
//                menu.addItem({
//                    let item = NSMenuItem()
//                    item.title = "copy unicode to pasteboard"
//                    item.target = self
//                    item.action = #selector(FontScrollView.copyClicked(_:))
//                    return item
//                    }())
//                menu.addItem(.separator())
//                menu.addItem(withTitle: "name: \(self.nowCharacterInfo.name)", action: nil, keyEquivalent: "")
//                menu.addItem(withTitle: "code: \(self.nowCharacterInfo.code)", action: nil, keyEquivalent: "")
//                return menu
//            }(), with: event, for: sender)
//        }
    }
}

extension ShowViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSMakeSize(50, 50)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
