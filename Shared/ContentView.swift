//
//  ContentView.swift
//  Shared
//
//  Created by 李毅 on 2020/7/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: IconfontPreviewDocument

//    @State var dataExample = (0 ..< 21).map { $0 }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(document.fontManager.characterInfos, id: \.self) { characterInfo in
                    Color.orange.frame(width: 100, height: 100)
                        .overlay(FontLabel(characterInfo: characterInfo)
                            .font(document.fontManager.fontOfSize(32)))
                }
            }
        }
    }
}

private extension ContentView {
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(IconfontPreviewDocument()))
    }
}

struct FontLabel: View {
    var characterInfo: CharacterInfo
    @State var showingSheet = false

    var stringValue: String? {
        if let charCode = UInt32(characterInfo.code, radix: 16), let unicode = UnicodeScalar(charCode) {
            return String(unicode)
        }
        return nil
    }

    var body: some View {
        Button {
            showingSheet = true
        } label: {
            Text(stringValue ?? "")
        }.alert(isPresented: $showingSheet, content: {
            Alert(title: Text(characterInfo.code), message: Text(characterInfo.name), dismissButton: .default(Text("woo")))
        })
//        .actionSheet(isPresented: $showingSheet) {
//            ActionSheet(title: Text(characterInfo.code), message: Text(characterInfo.name), buttons: [.default(Text("woo"))])
//        }
    }
}
