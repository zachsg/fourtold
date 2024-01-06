//
//  FTTagStats.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/4/24.
//

import Foundation

struct FTTagStats: Identifiable {
    var id: UUID = UUID()
    var title: String
    var usedMostRecent: Date
    var uses: [FTTagSubStats]
    var count: Int
}
