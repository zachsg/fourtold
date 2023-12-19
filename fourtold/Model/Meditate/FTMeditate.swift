//
//  FTMeditation.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import Foundation
import SwiftData

@Model
class FTMeditate: FTActivity {
    var id = UUID()
    var startDate: Date
    var timeOfDay: FTTimeOfDay
    var startMood: FTMood
    var endMood: FTMood
    var type: FTMeditateType
    var duration: Int
    var goal: Int?
    
    init(startDate: Date, timeOfDay: FTTimeOfDay, startMood: FTMood, endMood: FTMood, type: FTMeditateType, duration: Int) {
        self.startDate = startDate
        self.timeOfDay = timeOfDay
        self.startMood = startMood
        self.endMood = endMood
        self.type = type
        self.duration = duration
    }
}
