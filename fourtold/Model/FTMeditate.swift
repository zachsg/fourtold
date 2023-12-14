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
    var type: FTMeditateType
    var duration: Int
    var goal: Int?
    
    init(startDate: Date, type: FTMeditateType, duration: Int) {
        self.startDate = startDate
        self.type = type
        self.duration = duration
    }
}
