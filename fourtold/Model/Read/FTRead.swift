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
    var timeOfDay: FTTimeOfDay
    var startMood: FTMood
    var endMood: FTMood
    var type: FTReadType
    var genre: FTReadGenre
    var duration: Int
    var goal: Int?
    var isTimed: Bool
    
    init(id: UUID = UUID(), startDate: Date, timeOfDay: FTTimeOfDay, startMood: FTMood, endMood: FTMood, type: FTReadType, genre: FTReadGenre, duration: Int, goal: Int? = nil, isTimed: Bool) {
        self.id = id
        self.startDate = startDate
        self.timeOfDay = timeOfDay
        self.startMood = startMood
        self.endMood = endMood
        self.type = type
        self.genre = genre
        self.duration = duration
        self.goal = goal
        self.isTimed = isTimed
    }
}
