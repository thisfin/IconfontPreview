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
    var fontManager: FontManager!

    override func loadView() {
        view = DragView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.frame = NSRect(origin: .zero, size: NSMakeSize(800, 600))

        collectionView = NSCollectionView().next {
            $0.collectionViewLayout = NSCollectionViewFlowLayout()
            $0.register(SimpleCollectionViewItem.classForCoder(), forItemWithIdentifier: NSUserInterfaceItemIdentifier(SimpleCollectionViewItem.className()))
            $0.dataSource = self
            $0.delegate = self
            $0.allowsMultipleSelection = false
        }

        let scrollView = NSScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
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
        return fontManager.characterInfos.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: SimpleCollectionViewItem.className()), for: indexPath)
        if let item = collectionViewItem as? SimpleCollectionViewItem {
            item.fontManager = fontManager
            item.configData(characterInfo: fontManager.characterInfos[indexPath.item])
        }
        return collectionViewItem
    }
}

extension ShowViewController: NSCollectionViewDelegate {
}

extension ShowViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSMakeSize(60, 60)
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
