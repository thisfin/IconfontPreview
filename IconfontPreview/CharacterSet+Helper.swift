//
//  CharacterSet+Helper.swift
//  IconfontPreview
//
//  Created by fin on 2017/6/25.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import Foundation

extension CharacterSet {
    func allCharacters() -> [Character] {
        var result = [Character]()
        for plane: UInt8 in 0...16 where self.hasMember(inPlane: plane) {
            for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), self.contains(uniChar) {
                    result.append(Character(uniChar))
                }
            }
        }
        return result
    }
}

extension Character {
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
}
