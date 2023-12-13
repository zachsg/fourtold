//
//  FTMeditation.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import Foundation
import SwiftData

@Model
class FTMeditation: FTActivity {
    var id = UUID()
    var startDate: Date
    var type: FTMeditationType
    var duration: Int
    var goal: Int?
    
    init( startDate: Date, type: FTMeditationType, duration: Int) {
        self.startDate = startDate
        self.type = type
        self.duration = duration
    }
}
