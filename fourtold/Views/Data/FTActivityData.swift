//
//  FTActivityData.swift
//  fourtold
//
//  Created by Zach Gottlieb on 4/24/24.
//

import Foundation

class FTActivityData {
    static let all: [any FTActivity] = FTMeditateData.all + FTBreathData.all + FTReadData.all
}

class FTMeditateData {
    static let date: Date = Date.now
    
    static let all: [FTMeditate] = [
        FTMeditate(startDate: date, timeOfDay: date.timeOfDay(), startMood: .neutral, endMood: .pleasant, type: .timed, duration: 300),
        FTMeditate(startDate: date.addingTimeInterval(-86400), timeOfDay: date.addingTimeInterval(-86400).timeOfDay(), startMood: .unpleasant, endMood: .neutral, type: .open, duration: 60)
    ]
}

class FTBreathData {
    static let date: Date = Date.now
    
    static let all: [FTBreath] = [
        FTBreath(startDate: date, timeOfDay: date.timeOfDay(), startMood: .neutral, endMood: .unpleasant, type: .four78, duration: 180, rounds: 6),
        FTBreath(startDate: date.addingTimeInterval(-21600), timeOfDay: date.addingTimeInterval(-21600).timeOfDay(), startMood: .veryUnpleasant, endMood: .unpleasant, type: .box, duration: 240, rounds: 6)
    ]
}

class FTReadData {
    static let date: Date = Date.now
    
    static let all: [FTRead] = [
        FTRead(startDate: date, timeOfDay: date.timeOfDay(), startMood: .unpleasant, endMood: .pleasant, type: .article, genre: .business, duration: 600, isTimed: false)
    ]
}
