//
//  GroundSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftUI

struct GroundSheet: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(groundGoalKey) var groundGoal: Int = groundGoalDefault
    
    @Binding var showingSheet: Bool
    
    @State private var groundType: FTGroundType = .timed
    @State private var startDate: Date = .now
    @State private var mood: FTMood = .neutral
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Grounding details") {
                    Picker(selection: $groundType, label: Text("Grounding type")) {
                        ForEach(FTGroundType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    if groundType == .timed {
                        Stepper(value: $groundGoal, in: 60...5400, step: 60) {
                            Label(
                                title: {
                                    HStack {
                                        Text("Goal:")
                                        Text(groundGoal / 60, format: .number)
                                            .bold()
                                        Text("min")
                                    }
                                }, icon: {
                                    Image(systemName: groundType == .open ? meditateOpenSystemImage : meditateTimedSystemImage)
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
            .navigationTitle("Ground")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                    .foregroundStyle(.rest)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        GroundingView(healthKitController: healthKitController, groundType: $groundType, groundGoal: $groundGoal, startDate: $startDate, mood: $mood, showingSheet: $showingSheet)
                    }
                    .foregroundStyle(.rest)
                }
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return GroundSheet(healthKitController: healthKitController, showingSheet: .constant(true))
}
