//
//  FTTagType.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import Foundation

enum FTTagType: String, Codable, CaseIterable, Comparable {
    case activity, event, food, medication, supplement, other
    
    static func < (lhs: FTTagType, rhs: FTTagType) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}
