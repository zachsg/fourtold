//
//  Four78ingView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/29/24.
//

import SwiftUI

struct Four78ingView: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var rounds: Int
    @Binding var elapsed: TimeInterval
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var date: Date
    @Binding var type: FTBreathType
    @Binding var path: NavigationPath

    @State private var vibe = false

    @State private var isTimerRunning = true
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var counter = 0
    @State private var count = 0.0
    @State private var holdCount = 0.0
    @State private var round = 1
    @State private var status: FTBreathStatus = .inhale

    @State private var session = WKExtendedRuntimeSession()
    @State private var delegate = WKDelegate()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                .frame(width: 32, height: 32)
                .scaleEffect(CGSize(width: count * 2.2, height: count * 2.2), anchor: .center)
                .foregroundStyle(.rest.opacity(0.5))

            VStack {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("Round \(round)")
                        .font(.headline)
                    Text(" of \(rounds)")
                        .font(.footnote)
                }

                VStack {
                    Text("\(counter == 0 ? " " : "\(counter)")")
                        .font(.largeTitle.bold())

                    Text(status.rawValue.capitalized)
                        .font(.title3.bold())
                }
                .padding()

                Text("Tap to end".uppercased())
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("\(type.rawValue) Breathing")
        .sensoryFeedback(.impact(flexibility: .solid), trigger: vibe)
        .onTapGesture {
            rounds = round
            timerStopped()
        }
        .onAppear(perform: {
            endMood = mood
        })
        .onReceive(timer) { _ in
            if round > rounds {
                timerStopped()
            }

            if isTimerRunning {
                elapsed += 0.1

                if status == .inhale {
                    withAnimation {
                        counter = Int(count.rounded())
                    }

                    if count < 4 {
                        withAnimation {
                            count += 0.1
                        }
                    } else {
                        vibe.toggle()
                        status = .holdInhale
                    }
                } else if status == .holdInhale {
                    withAnimation {
                        counter = Int(holdCount.rounded())
                    }

                    if holdCount < 7 {
                        holdCount += 0.1
                    } else {
                        vibe.toggle()
                        status = .exhale
                        holdCount = 0
                    }
                } else {
                    withAnimation {
                        counter = Int((count * 2).rounded())
                    }

                    if count > 0 {
                        withAnimation {
                            count -= 0.05
                        }
                    } else {
                        vibe.toggle()
                        status = .inhale
                        withAnimation {
                            round += 1
                        }
                        count = 0
                    }
                }
            }
        }
        .onAppear(perform: {
            endMood = mood
            session.delegate = delegate
            session.start()
        })
    }

    func timerStopped() {
        if isTimerRunning {
            stopTimer()
            WKInterfaceDevice.current().play(.notification)
            path.append(BreatheStatus.done)
        } else {
            startTimer()
        }
        isTimerRunning.toggle()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    func startTimer() {
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
}

#Preview {
    Four78ingView(healthKitController: HealthKitController(), rounds: .constant(4), elapsed: .constant(0), mood: .constant(.neutral), endMood: .constant(.neutral), date: .constant(.now), type: .constant(.four78), path: .constant(NavigationPath()))
}
