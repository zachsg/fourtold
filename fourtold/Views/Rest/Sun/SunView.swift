//
//  SunView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftUI

struct SunView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController
    
    @Binding var sunType: FTSunType
    @Binding var sunGoal: Int
    @Binding var startDate: Date
    @Binding var mood: FTMood
    @Binding var showingSheet: Bool
    
    @State private var endMood: FTMood = .neutral
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(goal: $sunGoal, showingAlert: $showingAlert, elapsed: $elapsed, color: .rest, isTimed: sunType == .timed, notificationTitle: "Sun Exposure Done", notificationSubtitle: "You completed your sun exposure goal.")
        }
        .navigationTitle("Sunning")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
            endMood = mood
        })
        .sheet(isPresented: $showingAlert, content: {
            SunDoneSheet(healthKitController: healthKitController, type: $sunType, startDate: $startDate, elapsed: $elapsed, goal: $sunGoal, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingAlert: $showingAlert)
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return SunView(healthKitController: healthKitController, sunType: .constant(.timed), sunGoal: .constant(300), startDate: .constant(.now), mood: .constant(.neutral), showingSheet: .constant(true))
}

