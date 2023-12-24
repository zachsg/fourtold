//
//  MeditationsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import SwiftUI

struct MeditationsSheet: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(meditateGoalKey) var meditateGoal: Int = meditateGoalDefault
    
    @Binding var showingSheet: Bool
    
    @State private var meditateType: FTMeditateType = .timed
    @State private var startDate: Date = .now
    @State private var mood: FTMood = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Meditation details") {
                    Picker(selection: $meditateType, label: Text("Meditation type")) {
                        ForEach(FTMeditateType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    if meditateType == .timed {
                        Stepper(value: $meditateGoal, in: 60...5400, step: 60) {
                            Label(
                                title: {
                                    HStack {
                                        Text("Goal:")
                                        Text(meditateGoal / 60, format: .number)
                                            .bold()
                                        Text("min")
                                    }
                                }, icon: {
                                    Image(systemName: meditateType == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
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
            .navigationTitle("Meditate")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(.rest)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        MeditatingView(healthKitController: healthKitController, meditateType: $meditateType, meditateGoal: $meditateGoal, startDate: $startDate, mood: $mood, showingSheet: $showingSheet)
                    }
                    .foregroundStyle(.rest)
                }
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return MeditationsSheet(healthKitController: healthKitController, showingSheet: .constant(true))
}
