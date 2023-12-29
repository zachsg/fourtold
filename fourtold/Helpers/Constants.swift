//
//  Constants.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import Foundation
import SwiftUI

// MARK: - App
let appName = "4told"

let cancelSystemImage = "xmark.circle"
let arrowSystemImage = "arrowshape.forward"
let progressSystemImage = "location.north.circle.fill"

// MARK: - User
let userAgeKey = "userAge"
let userAgeDefault = 30
let userGenderKey = "userGender"
let userGenderDefault: FTGender = .female
let userSystemImage = "person.crop.circle"

// MARK: - Home
let homeTitle = "Home"
let homeSystemImage = "house.circle"

// MARK: - Move
let moveTitle = "Move"
let moveSystemImage = "figure.walk.circle"

// Steps
let hasDailyStepsGoalKey = "hasDailyStepsGoal"
let hasDailyStepsGoalDefault = true
let dailyStepsGoalKey = "dailyStepsGoal"
let dailyStepsGoalDefault = 10000
let stepsSystemImage = "figure.walk"

// Distance
let hasWalkRunDistanceKey = "hasWalkRunDistance"
let hasWalkRunDistanceDefault = true
let useMilesKey = "useMiles"
let useMilesDefault = true
let distanceSystemImage = "ruler"

// Mobility
let mobilityTitle = "Mobility"

let sweatTitle = "Sweat"
let sweatSystemImage = "drop.circle"

// VO2 max
let hasVO2Key = "hasVO2"
let hasVO2Default = true
let vO2SystemImage = "heart"

// Lift
let buildTitle = "Build"
let buildSystemImage = "scalemass.fill"

// MARK: - Rest
let restTitle = "Rest"
let restSystemImage = "sleep.circle"

// Time in Daylight
let hasTimeInDaylightKey = "hasTimeInDaylight"
let dailyTimeInDaylightGoalKey = "dailyTimeInDaylightGoal"
let dailyTimeInDaylightGoalDefault = 1800
let timeInDaylightSystemImage = "sun.max"
let timeInDaylightTitle = "Time in daylight"

// Breath
let breathTitle = "Breath"
let breathSystemImage = "lungs"
let breathTypeKey = "breathType"
let breathTypeDefault: FTBreathType = .four78

// Meditate
let meditateTitle = "Meditate"
let meditateSystemImage = "brain"
let meditateGoalKey = "meditateGoal"
let meditateGoalDefault = 600 // 10 minutes
let meditateOpenSystemImage = "stopwatch"
let meditateTimedSystemImage = "alarm"

// Journal
let journalTitle = "Journal"
let journalSystemImage = "square.and.pencil"

// Read
let readTitle = "Read"
let readSystemImage = "book"
let readOpenSystemImage = "stopwatch"
let readTimedSystemImage = "alarm"
let readGoalKey = "readGoal"
let readGoalDefault = 1800 // 30 minutes

// Sun
let sunTitle = "Sun exposure"
let sunSystemImage = "sun.max"
let sunGoalKey = "sunGoal"
let sunGoalDefault = 600 // 10 minutes

// Ground
let groundTitle = "Grounding"
let groundSystemImage = "globe.americas"
let groundGoalKey = "groundGoal"
let groundGoalDefault = 600 // 10 minutes

// MARK: -  Settings
let settingsTitle = "Settings"
let settingsSystemImage = "gearshape"
