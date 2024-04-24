//
//  Four78DoneSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftData
import SwiftUI

struct BreathDoneSheet: View {
    @Environment(\.modelContext) var modelContext
    @Environment(HKController.self) private var hkController
    
    let date: Date
    let elapsed: TimeInterval
    
    @Binding var type: FTBreathType
    @Binding var rounds: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var showingSheet: Bool
    @Binding var showingMainSheet: Bool
    
    var body: some View {
        VStack {
            Text("Done \(type.rawValue.capitalized) Breathing")
                .font(.title)
                .padding(.bottom, 8)
            
            VStack {
                if rounds > 1 {
                    Text("You did \(rounds) \(rounds == 1 ? "round" : "rounds") of \(type.rawValue) breathing.")
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
                        
                        hkController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: date)
                        
                        let breath = FTBreath(startDate: date, timeOfDay: date.timeOfDay(), startMood: mood, endMood: endMood, type: type, duration: Int(elapsed.rounded()), rounds: rounds)

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
    let hkController = HKController()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTBreath.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return BreathDoneSheet(date: .now, elapsed: 300.0, type: .constant(.four78), rounds: .constant(4), mood: .constant(.neutral), endMood: .constant(.neutral), showingSheet: .constant(true), showingMainSheet: .constant(true))
        .modelContainer(sharedModelContainer)
        .environment(hkController)
}
