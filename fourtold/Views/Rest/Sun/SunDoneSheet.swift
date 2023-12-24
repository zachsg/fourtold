//
//  SunDoneSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftUI

struct SunDoneSheet: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController
    
    @Binding var type: FTSunType
    @Binding var startDate: Date
    @Binding var elapsed: TimeInterval
    @Binding var goal: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var showingSheet: Bool
    @Binding var showingAlert: Bool
    
    var body: some View {
        VStack {
            Text("Done Sunning")
                .font(.title)
                .padding(.bottom, 8)
            
            VStack {
                if elapsed < 30 {
                    Text("You got sun exposure for less than 1 minute.")
                    Text("You have to do at least a minute to log it!")
                        .font(.footnote)
                } else if type == .timed {
                    Text("You got sun exposure for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full))")
                    Text("(\((elapsed / Double(goal) * 100).rounded() / 100, format: .percent) of your goal)")
                } else {
                    Text("You got sun exposure for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full)).")
                }
            }
            .padding(.bottom, 12)
            
            if elapsed > 30 {
                VStack {
                    Divider()
                    
                    VStack {
                        Text("How're you feeling now?")
                            .font(.headline)
                        MoodPicker(mood: $endMood, color: .rest) {
                            Text("How're you feeling now?")
                        }
                        .labelsHidden()
                    }
                    .padding()
                    
                    Divider()
                }
            }
            
            HStack(alignment: .center) {
                Button("Cancel", role: .cancel) {
                    NotificationController.cancelAllPending()
                    
                    showingAlert.toggle()
                    showingSheet.toggle()
                }
                .foregroundStyle(.rest)
                .padding()
                
                if elapsed > 30 {
                    Button("Save") {
                        NotificationController.cancelAllPending()
                        
                        healthKitController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: startDate)
                        
                        let sun = FTSun(startDate: startDate, timeOfDay: startDate.timeOfDay(), startMood: mood, endMood: endMood, type: type, duration: elapsed.secondsToMinutesRounded())
                        
                        modelContext.insert(sun)
                        
                        showingAlert.toggle()
                        showingSheet.toggle()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.rest)
                }
            }
        }
    }
}

#Preview {
    SunDoneSheet(healthKitController: HealthKitController(), type: .constant(.timed), startDate: .constant(.now), elapsed: .constant(300.0), goal: .constant(500), mood: .constant(.neutral), endMood: .constant(.neutral), showingSheet: .constant(true), showingAlert: .constant(true))
}