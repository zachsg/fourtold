//
//  MeditatingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import SwiftUI

struct MeditatingView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var meditationType: FTMeditationType
    @Binding var meditationGoal: Int
    @Binding var startDate: Date
    @Binding var showingSheet: Bool
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(meditationType: $meditationType, meditationGoal: $meditationGoal, showingAlert: $showingAlert, elapsed: $elapsed)
        }
        .navigationTitle("Meditating")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
        })
        .alert("Done Meditating", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {
                NotificationController.cancelAllPending()
                
                showingAlert.toggle()
                showingSheet.toggle()
            }
            
            Button("Save") {
                NotificationController.cancelAllPending()
                
                let mediation = FTMeditation(startDate: startDate, type: meditationType, duration: Int(TimeInterval(elapsed)))
                modelContext.insert(mediation)
                showingAlert.toggle()
                showingSheet.toggle()
            }
        }
    }
}

#Preview {
    MeditatingView(meditationType: .constant(.timed), meditationGoal: .constant(300), startDate: .constant(.now), showingSheet: .constant(true))
}
