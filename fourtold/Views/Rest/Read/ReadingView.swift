//
//  ReadingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/14/23.
//

import SwiftUI

struct ReadingView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController
    
    @Binding var readType: FTReadType
    @Binding var genre: FTReadGenre
    @Binding var mood: FTMood
    @Binding var isTimed: Bool
    @Binding var readGoal: Int
    @Binding var startDate: Date
    @Binding var showingSheet: Bool
    
    @State private var endMood: FTMood = .neutral
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(goal: $readGoal, showingAlert: $showingAlert, elapsed: $elapsed, color: .rest, isTimed: isTimed, notificationTitle: "Reading Done", notificationSubtitle: "You completed your reading goal.")
        }
        .navigationTitle("Reading")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
            endMood = mood
        })
        .sheet(isPresented: $showingAlert, content: {
            ReadingDoneSheet(healthKitController: healthKitController, type: $readType, genre: $genre, isTimed: $isTimed, startDate: $startDate, elapsed: $elapsed, goal: $readGoal, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingAlert: $showingAlert)
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
        })
    }
    
    func elapsedRounded() -> Int {
        Int((elapsed / 60.0).rounded()) * 60
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return ReadingView(healthKitController: healthKitController, readType: .constant(.book), genre: .constant(.fantasy), mood: .constant(.neutral), isTimed: .constant(true), readGoal: .constant(1800), startDate: .constant(.now), showingSheet: .constant(true))
}

