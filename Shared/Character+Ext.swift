//
//  Character+Ext.swift
//  IconfontPreview
//
//  Created by 李毅 on 2020/9/17.
//

import Foundation

extension Character {
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}
