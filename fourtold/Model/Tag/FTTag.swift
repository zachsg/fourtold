//
//  FTTag.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import Foundation
import SwiftData

@Model
class FTTag {
    var id = UUID()
    var date: Date = Date.now
    var timeOfDay: FTTimeOfDay = FTTimeOfDay.morning
    var mood: FTMood = FTMood.neutral
    var title: String = ""
    var type: FTTagType = FTTagType.other
    
    init(id: UUID = UUID(), date: Date, timeOfDay: FTTimeOfDay, mood: FTMood, title: String, type: FTTagType) {
        self.id = id
        self.date = date
        self.timeOfDay = timeOfDay
        self.mood = mood
        self.title = title
        self.type = type
    }
}
