//
//  BreatheSetup.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/29/24.
//

import SwiftData
import SwiftUI

struct BreatheSetup: View {
    @Bindable var healthKitController: HealthKitController

    @Binding var path: NavigationPath

    @AppStorage(breathTypeKey) var breathType: FTBreathType = breathTypeDefault
    @AppStorage(four78RoundsKey) var four78Rounds: Int = four78RoundsDefault
    @AppStorage(boxRoundsKey) var boxRounds: Int = boxRoundsDefault

    @State private var mood: FTMood = .neutral
    @State private var endMood: FTMood = .neutral
    @State private var rounds = 8
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
            .onChange(of: breathType, {
                resetRounds()
            })

            if breathType == .four78 {
                Stepper(value: $rounds, in: 4...8) {
                    VStack {
                        Text("Rounds")
                            .font(.footnote.bold())
                        Text(rounds, format: .number)
                            .font(.title.bold())
                    }
                }
            } else if breathType == .box {
                Stepper(value: $rounds, in: 20...75, step: 5) {
                    VStack(alignment: .leading) {
                        VStack {
                            Text("Rounds")
                                .font(.footnote.bold())

                            Text(rounds, format: .number)
                                .font(.title.bold())

                            Text("\(rounds * 16 / 60) minutes")
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
        .onAppear {
            resetRounds()
        }
        .navigationDestination(for: BreatheStatus.self) { option in
            switch option {
            case .four78:
                Four78ingView(healthKitController: healthKitController, rounds: $rounds, elapsed: $elapsed, mood: $mood, endMood: $endMood, date: $date, type: $breathType, path: $path)
            case .box:
                BoxingView(healthKitController: healthKitController, rounds: $rounds, elapsed: $elapsed, mood: $mood, endMood: $endMood, date: $date, type: $breathType, path: $path)
            case .done:
                DoneBreathingView(healthKitController: healthKitController, date: date, elapsed: elapsed, type: $breathType, rounds: $rounds, mood: $mood, endMood: $endMood, path: $path)
            }
        }
    }

    private func resetRounds() {
        rounds = switch breathType {
        case .four78:
            four78Rounds
        case .box:
            boxRounds
        case .wimHof:
            3
        }
    }
}

#Preview {
    BreatheSetup(healthKitController: HealthKitController(), path: .constant(NavigationPath()))
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
