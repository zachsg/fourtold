//
//  FTSun.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/23/23.
//

import Foundation
import SwiftData

@Model
class FTSun: FTActivity {
    var id = UUID()
    var startDate: Date = Date.now
    var timeOfDay: FTTimeOfDay = FTTimeOfDay.morning
    var startMood: FTMood = FTMood.neutral
    var endMood: FTMood = FTMood.neutral
    var type: FTSunType = FTSunType.open
    var duration: Int = 0
    
    init(startDate: Date, timeOfDay: FTTimeOfDay, startMood: FTMood, endMood: FTMood, type: FTSunType, duration: Int) {
        self.startDate = startDate
        self.timeOfDay = timeOfDay
        self.startMood = startMood
        self.endMood = endMood
        self.type = type
        self.duration = duration
    }
}
