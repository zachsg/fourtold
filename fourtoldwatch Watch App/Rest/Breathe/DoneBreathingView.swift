//
//  DoneBreathingView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/29/24.
//

import SwiftData
import SwiftUI

struct DoneBreathingView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(HealthKitController.self) private var healthKitController

    let date: Date
    let elapsed: TimeInterval
    @Binding var type: FTBreathType
    @Binding var rounds: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood

    @Binding var path: NavigationPath

    var body: some View {
        Form {
            Section {
                if rounds > 1 {
                    Text("You did \(rounds) \(rounds == 1 ? "round" : "rounds") of \(type.rawValue) breathing.")
                } else {
                    Text("You have to do at least 1 round to save your breath work.")
                }

                if rounds > 1 {
                    MoodPicker(mood: $endMood, color: .rest) {
                        Text("How're you feeling?")
                    }
                }
            }

            Section {
                HStack(alignment: .center) {
                    Button("Cancel", role: .cancel) {
                        NotificationController.cancelAllPending()

                        path.removeLast(path.count-1)
                    }
                    .foregroundStyle(.rest)

                    if rounds > 1 {
                        Button("Save") {
                            NotificationController.cancelAllPending()

                            healthKitController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: date)

                            let breath = FTBreath(startDate: date, timeOfDay: date.timeOfDay(), startMood: mood, endMood: endMood, type: type, duration: Int(elapsed.rounded()), rounds: rounds)

                            modelContext.insert(breath)

                            path.removeLast(path.count)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.rest)
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Done \(type.rawValue)")
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return DoneBreathingView(date: .now, elapsed: 300.0, type: .constant(.four78), rounds: .constant(4), mood: .constant(.neutral), endMood: .constant(.neutral), path: .constant(NavigationPath()))
        .environment(healthKitController)
        .modelContainer(sharedModelContainer)
}
