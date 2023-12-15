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
    var type: FTBreathType
    var duration: Int
    var rounds: Int
    var breathsPerRound: Int
    var holdSecondsPerRound: [Int]
    
    init(id: UUID = UUID(), startDate: Date, type: FTBreathType, duration: Int, rounds: Int, breathsPerRound: Int = 0, holdSecondsPerRound: [Int] = []) {
        self.id = id
        self.startDate = startDate
        self.type = type
        self.duration = duration
        self.rounds = rounds
        self.breathsPerRound = breathsPerRound
        self.holdSecondsPerRound = holdSecondsPerRound
    }
}
