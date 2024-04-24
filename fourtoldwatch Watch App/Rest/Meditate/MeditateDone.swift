//
//  MeditateDone.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftUI

import SwiftData
import SwiftUI

struct MeditateDone: View {
    @Environment(\.modelContext) var modelContext
    @Environment(HealthKitController.self) private var healthKitController

    @Binding var type: FTMeditateType
    @Binding var startDate: Date
    @Binding var elapsed: TimeInterval
    @Binding var goal: Int
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var path: NavigationPath

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    if elapsed < 30 {
                        Text("You meditated for less than 1 minute.")
                        Text("You have to do at least a minute to log it!")
                            .font(.footnote)
                    } else if type == .timed {
                        Text("You meditated for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full))")
                        Text("\((elapsed / Double(goal) * 100).rounded() / 100, format: .percent) of your goal")
                            .font(.footnote)
                    } else {
                        Text("You meditated for \(elapsed.secondsAsTimeRoundedToMinutes(units: .full)).")
                    }
                }

                if elapsed > 30 {
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

                    if elapsed > 30 {
                        Button("Save") {
                            NotificationController.cancelAllPending()

                            healthKitController.setMindfulMinutes(seconds: elapsed.secondsToMinutesRounded(), startDate: startDate)

                            healthKitController.getMindfulMinutesToday()

                            let mediation = FTMeditate(startDate: startDate, timeOfDay: startDate.timeOfDay(), startMood: mood, endMood: endMood, type: type, duration: elapsed.secondsToMinutesRounded())

                            modelContext.insert(mediation)

                            path.removeLast(path.count)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.rest)
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Done Meditating")
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return MeditateDone(type: .constant(.timed), startDate: .constant(.now), elapsed: .constant(300.0), goal: .constant(500), mood: .constant(.neutral), endMood: .constant(.neutral), path: .constant(NavigationPath()))
        .environment(healthKitController)
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}