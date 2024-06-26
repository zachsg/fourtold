//
//  MeditatingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import SwiftUI

struct MeditatingView: View {
    @Binding var meditateType: FTMeditateType
    @Binding var meditateGoal: Int
    @Binding var startDate: Date
    @Binding var mood: FTMood
    @Binding var showingSheet: Bool
    
    @State private var endMood: FTMood = .neutral
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(goal: $meditateGoal, showingAlert: $showingAlert, elapsed: $elapsed, color: .rest, isTimed: meditateType == .timed, notificationTitle: "Meditation Done", notificationSubtitle: "You completed your mediation goal.")
        }
        .navigationTitle("Meditating")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
            endMood = mood
        })
        .sheet(isPresented: $showingAlert, content: {
            MeditationDoneSheet(type: $meditateType, startDate: $startDate, elapsed: $elapsed, goal: $meditateGoal, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingAlert: $showingAlert)
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    MeditatingView(meditateType: .constant(.timed), meditateGoal: .constant(300), startDate: .constant(.now), mood: .constant(.neutral), showingSheet: .constant(true))
}
