//
//  IconfontPreviewDocument.swift
//  Shared
//
//  Created by 李毅 on 2020/7/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct IconfontPreviewDocument: FileDocument {
    var fontManager: FontManager

    static var readableContentTypes: [UTType] {
        [.ttf]
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
            let manager = FontManager(data: data) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        fontManager = manager
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return .init(regularFileWithContents: Data())
    }

    init() {
        fontManager = FontManager(data: Data())!
    }
}
