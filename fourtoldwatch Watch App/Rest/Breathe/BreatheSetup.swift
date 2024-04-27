//
//  BreatheSetup.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/29/24.
//

import SwiftData
import SwiftUI

struct BreatheSetup: View {
    @Binding var path: NavigationPath

    @AppStorage(breathTypeKey) var breathType: FTBreathType = breathTypeDefault
    @AppStorage(four78RoundsKey) var four78Rounds: Int = four78RoundsDefault
    @AppStorage(boxRoundsKey) var boxRounds: Int = boxRoundsDefault

    @State private var mood: FTMood = .neutral
    @State private var endMood: FTMood = .neutral
    @State private var elapsed: TimeInterval = 0
    @State private var date: Date = .now

    var body: some View {
        Form {
            Picker(selection: $breathType.animation(), label: Text("Breath type")) {
                ForEach(FTBreathType.allCases, id: \.self) { type in
                    switch(type) {
                    case .four78:
                        Text("4-7-8 breath")
                    case .box:
                        Text("Box breath")
                    case .wimHof:
                        Text("Wim Hof method -- coming soon")
                    }
                }
            }

            if breathType == .four78 {
                Stepper(value: $four78Rounds, in: 4...8) {
                    VStack {
                        Text("Rounds")
                            .font(.footnote.bold())
                        Text(four78Rounds, format: .number)
                            .font(.title.bold())
                    }
                }
            } else if breathType == .box {
                Stepper(value: $boxRounds, in: 20...75, step: 5) {
                    VStack(alignment: .leading) {
                        VStack {
                            Text("Rounds")
                                .font(.footnote.bold())

                            Text(boxRounds, format: .number)
                                .font(.title.bold())

                            Text("\(boxRounds * 16 / 60) minutes")
                                .font(.footnote.bold())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            MoodPicker(mood: $mood, color: .rest) {
                Text("How're you feeling?")
            }

            Section {
                Button {
                    if breathType == .four78 {
                        path.append(BreatheStatus.four78)
                    } else if breathType == .box {
                        path.append(BreatheStatus.box)
                    }
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
        .navigationDestination(for: BreatheStatus.self) { option in
            switch option {
            case .four78:
                Four78ingView(rounds: $four78Rounds, elapsed: $elapsed, mood: $mood, endMood: $endMood, date: $date, type: $breathType, path: $path)
            case .box:
                BoxingView(rounds: $boxRounds, elapsed: $elapsed, mood: $mood, endMood: $endMood, date: $date, type: $breathType, path: $path)
            case .done:
                DoneBreathingView(date: date, elapsed: elapsed, type: $breathType, rounds: breathType == .four78 ? $four78Rounds : $boxRounds, mood: $mood, endMood: $endMood, path: $path)
            }
        }
    }
}

#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return BreatheSetup(path: .constant(NavigationPath()))
        .modelContainer(sharedModelContainer)
}
