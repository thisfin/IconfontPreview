//
//  UTType+Ext.swift
//  IconfontPreview
//
//  Created by 李毅 on 2020/9/17.
//

import Foundation

import UniformTypeIdentifiers

extension UTType {
    static var ttf: UTType {
        guard let type = UTType(filenameExtension: "ttf", conformingTo: .font) else {
            fatalError()
        }
        return type
//        UTType(importedAs: "com.example.plain-text")
    }
}
