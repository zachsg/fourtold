//
//  SunSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftUI

struct SunSheet: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(sunGoalKey) var sunGoal: Int = sunGoalDefault
    
    @Binding var showingSheet: Bool
    
    @State private var sunType: FTSunType = .timed
    @State private var startDate: Date = .now
    @State private var mood: FTMood = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Sun details") {
                    Picker(selection: $sunType, label: Text("Sun type")) {
                        ForEach(FTSunType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    if sunType == .timed {
                        Stepper(value: $sunGoal, in: 60...5400, step: 60) {
                            Label(
                                title: {
                                    HStack {
                                        Text("Goal:")
                                        Text(sunGoal / 60, format: .number)
                                            .bold()
                                        Text("min")
                                    }
                                }, icon: {
                                    Image(systemName: sunType == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
                                        .foregroundStyle(.rest)
                                }
                            )
                        }
                    }
                }
                
                Section("Mood") {
                    MoodPicker(mood: $mood, color: .rest) {
                        Text("How're you feeling?")
                    }
                }
            }
            .navigationTitle("Sun Exposure")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(.rest)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        SunView(healthKitController: healthKitController, sunType: $sunType, sunGoal: $sunGoal, startDate: $startDate, mood: $mood, showingSheet: $showingSheet)
                    }
                    .foregroundStyle(.rest)
                }
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return SunSheet(healthKitController: healthKitController, showingSheet: .constant(true))
}

