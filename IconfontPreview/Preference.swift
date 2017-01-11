//
//  Preference.swift
//  IconfontPreview
//
//  Created by wenyou on 2017/1/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Foundation

class Preference: NSObject {
    private static let selfInstance = Preference()

    private let ttfFilePathKey = "ttfFilePath"
    private let cssFilePathKey = "cssFilePath"

    public static var sharedInstance: Preference {
        return selfInstance
    }

    override private init() {
        super.init()
    }

    // ~/Library/Application Support/$(PRODUCT_BUNDLE_IDENTIFIER)/Preferences/filePath.plist
    let filePathDirectory: String = { // 配置文件目录
//        NSLog(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!)
//        NSLog(FileManager.default.homeDirectoryForCurrentUser.absoluteString)
        let infoDictionary = Bundle.main.infoDictionary
        let identifier: String = infoDictionary!["CFBundleIdentifier"] as! String
        return "\(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!)/\(identifier)/Preferences"
    }()
    func filePathFile() -> String  { // 配置文件地址
        return "\(filePathDirectory)/filePath.plist"
    }

    func writeFilePathInfo(_ filePathInfo: FilePathInfo) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePathFile()) { // 建目录
            if !fileManager.fileExists(atPath: filePathDirectory) {
                try! fileManager.createDirectory(atPath: filePathDirectory, withIntermediateDirectories: true)
            }
            fileManager.createFile(atPath: filePathFile(), contents: nil)
        }
        var dict: [String: String] = [:]
        dict[ttfFilePathKey] = filePathInfo.ttfFilePath
        dict[cssFilePathKey] = filePathInfo.cssFilePath
        (dict as NSDictionary).write(toFile: filePathFile(), atomically: false)
    }

    func readFilePahtInfo() -> FilePathInfo? { // 读文件
        if FileManager.default.fileExists(atPath: filePathFile()) {
            if let dict = NSDictionary(contentsOfFile: filePathFile()) {
                let d: [String : String] = dict as! [String : String]
                if let ttfFilePath = d[ttfFilePathKey], let cssFilePath = d[cssFilePathKey] {
                    return FilePathInfo(ttfFilePath: ttfFilePath, cssFilePath: cssFilePath)
                }
            }
        }
        return nil
    }
}

struct FilePathInfo {
    var ttfFilePath: String
    var cssFilePath: String
}
