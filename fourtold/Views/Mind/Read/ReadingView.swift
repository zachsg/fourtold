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
    @Binding var isTimed: Bool
    @Binding var readGoal: Int
    @Binding var startDate: Date
    @Binding var title: String
    @Binding var url: String
    @Binding var showingSheet: Bool
    
    @State private var showingAlert = false
    @State private var elapsed: TimeInterval = 0
    
    var body: some View {
        VStack {
            ReadTimerView(readType: $readType, readGoal: $readGoal, showingAlert: $showingAlert, elapsed: $elapsed, isTimed: $isTimed)
        }
        .navigationTitle("Reading")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            startDate = .now
        })
        .alert("Done Reading", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {
                NotificationController.cancelAllPending()
                
                showingAlert.toggle()
                showingSheet.toggle()
            }
            
            Button("Save") {
                NotificationController.cancelAllPending()
                
                healthKitController.setMindfulMinutes(seconds: Int(elapsed), startDate: startDate)
                
                let read = FTRead(startDate: startDate, type: readType, title: title, url: url, duration: Int(TimeInterval(elapsed)), isTimed: isTimed)
                
                modelContext.insert(read)
                showingAlert.toggle()
                showingSheet.toggle()
            }
        } message: {
            if isTimed {
                Text("You read for \(elapsed.secondsAsTime(units: .full)) (\((elapsed / Double(readGoal) * 100).rounded() / 100, format: .percent) of your goal).")
            } else {
                Text("You read for \(elapsed.secondsAsTime(units: .full)).")
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return ReadingView(healthKitController: healthKitController, readType: .constant(.book), isTimed: .constant(true), readGoal: .constant(1800), startDate: .constant(.now), title: .constant("Princess Bride"), url: .constant("https://www.google.com"),  showingSheet: .constant(true))
}

