//
//  GroundingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/23/23.
//

import SwiftUI

struct GroundingView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController
    
    @Binding var groundType: FTGroundType
    @Binding var groundGoal: Int
    @Binding var startDate: Date
    @Binding var mood: FTMood
    @Binding var showingSheet: Bool
    
    @State private var endMood: FTMood = .neutral
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(goal: $groundGoal, showingAlert: $showingAlert, elapsed: $elapsed, color: .rest, isTimed: groundType == .timed, notificationTitle: "Grounding Done", notificationSubtitle: "You completed your grounding goal.")
        }
        .navigationTitle("Grounding")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
            endMood = mood
        })
        .sheet(isPresented: $showingAlert, content: {
            GroundingDoneSheet(healthKitController: healthKitController, type: $groundType, startDate: $startDate, elapsed: $elapsed, goal: $groundGoal, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingAlert: $showingAlert)
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return GroundingView(healthKitController: healthKitController, groundType: .constant(.timed), groundGoal: .constant(300), startDate: .constant(.now), mood: .constant(.neutral), showingSheet: .constant(true))
}
