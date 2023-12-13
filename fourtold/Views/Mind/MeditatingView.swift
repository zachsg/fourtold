//
//  MeditatingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import SwiftUI

struct MeditatingView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var meditateType: FTMeditateType
    @Binding var meditateGoal: Int
    @Binding var startDate: Date
    @Binding var showingSheet: Bool
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            TimerView(meditationType: $meditateType, meditateGoal: $meditateGoal, showingAlert: $showingAlert, elapsed: $elapsed)
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
                
                let mediation = FTMeditate(startDate: startDate, type: meditateType, duration: Int(TimeInterval(elapsed)))
                modelContext.insert(mediation)
                showingAlert.toggle()
                showingSheet.toggle()
            }
        } message: {
            if meditateType == .timed {
                Text("You meditated for \(elapsed.secondsAsTime(units: .full)) (\((elapsed / Double(meditateGoal) * 100).rounded() / 100, format: .percent) of your goal).")
            } else {
                Text("You meditated for \(elapsed.secondsAsTime(units: .full)).")
            }
        }
    }
}

#Preview {
    MeditatingView(meditateType: .constant(.timed), meditateGoal: .constant(300), startDate: .constant(.now), showingSheet: .constant(true))
}
