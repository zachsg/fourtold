//
//  MeditateSetup.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct MeditateSetup: View {
    @Bindable var healthKitController: HealthKitController

    @Binding var path: NavigationPath

    @AppStorage(meditateGoalKey) var meditateGoal: Int = meditateGoalDefault

    @State private var meditateType: FTMeditateType = .timed
    @State private var startDate: Date = .now
    @State private var mood: FTMood = .neutral
    @State private var endMood: FTMood = .neutral
    @State private var elapsed: TimeInterval = 0

    var body: some View {
        Form {
            Section {
                Picker(selection: $meditateType, label: Text("Meditation type")) {
                    ForEach(FTMeditateType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }

                if meditateType == .timed {
                    Stepper(value: $meditateGoal, in: 60...5400, step: 60) {
                        VStack {
                            Text(meditateGoal / 60, format: .number)
                                .font(.title.bold())

                            Text("minutes")
                                .font(.footnote)
                        }
                    }
                }

                MoodPicker(mood: $mood, color: .rest) {
                    Text("How're you feeling?")
                }
            }

            Section {
                Button {
                    path.append(MeditateStatus.during)
                } label: {
                    HStack {
                        Spacer()
                        Text("Start")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .listRowBackground(Color.clear)
        }
        .navigationDestination(for: MeditateStatus.self) { option in
            if option == .during {
                MeditateDuring(healthKitController: healthKitController, meditateType: $meditateType, meditateGoal: $meditateGoal, startDate: $startDate, mood: $mood, endMood: $endMood, elapsed: $elapsed, path: $path)
            } else if option == .done {
                MeditateDone(healthKitController: healthKitController, type: $meditateType, startDate: $startDate, elapsed: $elapsed, goal: $meditateGoal, mood: $mood, endMood: $endMood, path: $path)
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()

    return MeditateSetup(healthKitController: healthKitController, path: .constant(NavigationPath()))
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}

