//
//  Four78DoneSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct Four78DoneSheet: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController
    
    let date: Date
    let elapsed: TimeInterval
    @Binding var rounds: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var showingSheet: Bool
    @Binding var showingMainSheet: Bool
    
    var body: some View {
        VStack {
            Text("Done 4-7-8 Breathing")
                .font(.title)
                .padding(.bottom, 8)
            
            VStack {
                if rounds > 1 {
                    Text("You did \(rounds) \(rounds == 1 ? "round" : "rounds") of 4-7-8 breathing.")
                } else {
                    Text("You have to do at least 1 round to save your breath work.")
                }
            }
            .padding(.bottom, 12)
            
            if rounds > 1 {
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
                    showingSheet.toggle()
                    showingMainSheet.toggle()
                }
                .foregroundStyle(.rest)
                .padding()
                
                if rounds > 1 {
                    Button("Save") {
                        NotificationController.cancelAllPending()
                        
                        healthKitController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: date)
                        
                        let breath = FTBreath(startDate: date, timeOfDay: date.timeOfDay(), startMood: mood, endMood: endMood, type: .four78, duration: Int(elapsed.rounded()), rounds: rounds)
                        
                        modelContext.insert(breath)
                        
                        showingSheet.toggle()
                        showingMainSheet.toggle()
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
    Four78DoneSheet(healthKitController: HealthKitController(), date: .now, elapsed: 300.0, rounds: .constant(4), mood: .constant(.neutral), endMood: .constant(.neutral), showingSheet: .constant(true), showingMainSheet: .constant(true))
}
