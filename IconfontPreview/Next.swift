//
//  Next.swift
//  IconfontPreview
//
//  Created by 李毅 on 2021/3/8.
//  Copyright © 2021 wenyou. All rights reserved.
//

import Foundation

protocol Next {}

extension Next where Self: Any {
    @inlinable func next(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

extension Next where Self: AnyObject {
    @inlinable func next(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Next {}
