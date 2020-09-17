//
//  IconfontPreviewApp.swift
//  Shared
//
//  Created by 李毅 on 2020/7/22.
//

import SwiftUI

@main
struct IconfontPreviewApp: App {
    var body: some Scene {
        DocumentGroup(viewing: IconfontPreviewDocument.self) { file in
            ContentView(document: file.$document)
                .navigationTitle(file.document.fontManager.fontName)
        }
    }
}
