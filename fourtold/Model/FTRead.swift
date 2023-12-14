//
//  FTRead.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import Foundation

import Foundation
import SwiftData

@Model
class FTRead: FTActivity {
    var id = UUID()
    var startDate: Date
    var type: FTReadType
    var title: String
    var comment: String
    var url: String
    var duration: Int
    var goal: Int?
    var isTimed: Bool
    
    init(id: UUID = UUID(), startDate: Date, type: FTReadType, title: String = "", comment: String = "", url: String = "", duration: Int, goal: Int? = nil, isTimed: Bool) {
        self.id = id
        self.startDate = startDate
        self.type = type
        self.title = title
        self.comment = comment
        self.url = url
        self.duration = duration
        self.goal = goal
        self.isTimed = isTimed
    }
}
