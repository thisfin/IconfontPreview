//
//  FilePermissions.swift
//  HostsManager
//
//  Created by wenyou on 2017/6/9.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

typealias URLHandleBlock = (_ url: URL) -> Void

class FilePermissions {
    static let sharedInstance = FilePermissions()

    private init() {
    }

    // 执行
    func handleFile(fileType: String, newPath: String, block: URLHandleBlock) {
        var isStale = false
        if let bookmarkData = UserDefaults.standard.object(forKey: getBookmarkKey(fileType: fileType)),
            bookmarkData is Data,
            let url = try! URL.init(resolvingBookmarkData: bookmarkData as! Data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale),
            url.path == newPath {
            _ = url.startAccessingSecurityScopedResource()
            block(url)
            url.stopAccessingSecurityScopedResource()
        }
    }

    // 增加书签
    func addBookmark(url: URL, fileType: String) {
        let bookmarkData = try! url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: getBookmarkKey(fileType: fileType))
    }

    // 生成书签 key
    func getBookmarkKey(fileType: String) -> String {
        return "bookmark_key_\(fileType)"
    }
}
