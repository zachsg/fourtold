//
//  FTBreath.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import Foundation
import SwiftData

@Model
class FTBreath: FTActivity {
    var id = UUID()
    var startDate: Date
    var timeOfDay: FTTimeOfDay
    var startMood: FTMood
    var endMood: FTMood
    var type: FTBreathType
    var duration: Int
    var rounds: Int
    var breathsPerRound: Int
    var holdSecondsPerRound: [Int]
    
    init(id: UUID = UUID(), startDate: Date, timeOfDay: FTTimeOfDay, startMood: FTMood, endMood: FTMood, type: FTBreathType, duration: Int, rounds: Int, breathsPerRound: Int = 0, holdSecondsPerRound: [Int] = []) {
        self.id = id
        self.startDate = startDate
        self.timeOfDay = timeOfDay
        self.startMood = startMood
        self.endMood = endMood
        self.type = type
        self.duration = duration
        self.rounds = rounds
        self.breathsPerRound = breathsPerRound
        self.holdSecondsPerRound = holdSecondsPerRound
    }
}
