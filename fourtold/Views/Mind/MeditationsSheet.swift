//
//  MeditationsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import SwiftData
import SwiftUI

struct MeditationsSheet: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditation.startDate, order: .reverse) var meditations: [FTMeditation]
    
    @AppStorage(meditateGoalKey) var meditateGoal: Int = 600
    
    @Binding var showingSheet: Bool
    
    @State private var meditationType: FTMeditationType = .timed
    @State private var startDate: Date = .now
    
    var body: some View {
        NavigationStack {
            Form {
                Picker(selection: $meditationType, label: Text("Meditation type")) {
                    ForEach(FTMeditationType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                
                if meditationType == .timed {
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
                                Image(systemName: "clock")
                            }
                        )
                    }
                }
            }
            .navigationTitle("Meditate")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        showingSheet.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Start") {
                        MeditatingView(meditationType: $meditationType, meditationGoal: $meditateGoal, startDate: $startDate, showingSheet: $showingSheet)
                    }
                }
            }
        }
    }
}

#Preview {
    MeditationsSheet(showingSheet: .constant(true))
        .modelContainer(for: FTMeditation.self)
}
