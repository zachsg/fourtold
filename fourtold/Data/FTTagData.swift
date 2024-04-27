//
//  FTTagData.swift
//  fourtold
//
//  Created by Zach Gottlieb on 4/24/24.
//

import Foundation

class FTTagData {
    static let date: Date = Date.now
    
    static let all: [FTTag] = [
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .neutral, title: "Sauna", type: .activity),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .unpleasant, title: "Cold Plunge", type: .activity),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement),
        FTTag(date: date, timeOfDay: date.timeOfDay(), mood: .pleasant, title: "Vitamin D", type: .supplement)
    ]
}
