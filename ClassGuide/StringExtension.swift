//
//  StringExtension.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/26/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

extension String {
    func chopSuffix(count: Int) -> String {
        if count < 1 { return self }
        var choppedString = self
        for _ in 1...count {
            choppedString = String(choppedString.characters.dropLast())
        }
        return choppedString
    }
}