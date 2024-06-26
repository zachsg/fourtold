//
//  ReadingDoneSheet.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/20/23.
//

import SwiftData
import SwiftUI

struct ReadingDoneSheet: View {
    @Environment(\.modelContext) var modelContext
    @Environment(HKController.self) private var hkController
    
    @Binding var type: FTReadType
    @Binding var genre: FTReadGenre
    @Binding var isTimed: Bool
    @Binding var startDate: Date
    @Binding var elapsed: TimeInterval
    @Binding var goal: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var showingSheet: Bool
    @Binding var showingAlert: Bool
    
    var body: some View {
        VStack {
            Text("Done Reading")
                .font(.title)
                .padding(.bottom, 8)
            
            VStack {
                if elapsed < 30 {
                    Text("You read for less than 1 minute.")
                    Text("You have to do at least a minute to log it!")
                        .font(.footnote)
                } else if isTimed {
                    Text("You read for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full))")
                    Text("(\((elapsed / Double(goal) * 100).rounded() / 100, format: .percent) of your goal)")
                } else {
                    Text("You read for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full)).")
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
                        
                        // Write mindful minutes to Apple Health
                        // hkController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: startDate)
                        
                        let read = FTRead(startDate: startDate, timeOfDay: startDate.timeOfDay(), startMood: mood, endMood: endMood, type: type, genre: genre, duration: elapsed.secondsToMinutesRounded(), isTimed: isTimed)
                        
                        modelContext.insert(read)
                        
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
    let hkController = HKController()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTRead.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ReadingDoneSheet(type: .constant(.book), genre: .constant(.fantasy), isTimed: .constant(true), startDate: .constant(.now), elapsed: .constant(300.0), goal: .constant(500), mood: .constant(.neutral), endMood: .constant(.neutral), showingSheet: .constant(true), showingAlert: .constant(true))
        .modelContainer(sharedModelContainer)
        .environment(hkController)
}
