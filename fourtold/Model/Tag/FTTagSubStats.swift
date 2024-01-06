//
//  FTDateAndTimeOfDay.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/5/24.
//

import Foundation

struct FTTagSubStats: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var timeOfDay: FTTimeOfDay
    var mood: FTMood
}
