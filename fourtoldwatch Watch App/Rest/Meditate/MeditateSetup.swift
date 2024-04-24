//
//  MeditateSetup.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct MeditateSetup: View {
    @Environment(HealthKitController.self) private var healthKitController
    
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
                            Text("Goal".uppercased())
                                .font(.footnote.bold())
                                .foregroundStyle(.rest)

                            Text(meditateGoal / 60, format: .number)
                                .font(.title.bold())

                            Text("minutes".uppercased())
                                .font(.footnote.bold())
                                .foregroundStyle(.rest)
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
                MeditateDuring(meditateType: $meditateType, meditateGoal: $meditateGoal, startDate: $startDate, mood: $mood, endMood: $endMood, elapsed: $elapsed, path: $path)
            } else if option == .done {
                MeditateDone(type: $meditateType, startDate: $startDate, elapsed: $elapsed, goal: $meditateGoal, mood: $mood, endMood: $endMood, path: $path)
            }
        }
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

    return MeditateSetup(path: .constant(NavigationPath()))
        .environment(healthKitController)
        .modelContainer(sharedModelContainer)
}

