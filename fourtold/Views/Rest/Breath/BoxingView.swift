//
//  BoxingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/11/24.
//

import SwiftUI

struct BoxingView: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var type: FTBreathType
    @Binding var rounds: Int
    @Binding var mood: FTMood
    @Binding var showingMainSheet: Bool

    @State private var endMood: FTMood = .neutral
    @State private var showingSheet = false
    @State private var elapsed: TimeInterval = 0

    @State private var vibe = false

    let date: Date = .now

    @State private var isTimerRunning = true
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var counter = 0
    @State private var count = 0.0
    @State private var holdCount = 0.0
    @State private var round = 1
    @State private var status: FTBreathStatus = .inhale

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .scaleEffect(CGSize(width: count * 3, height: count * 3), anchor: .center)
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
                        .font(.title.bold())
                }
                .padding()

                Text("Tap to end early")
                    .font(.footnote.italic())
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Box Breathing")
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

                    if holdCount < 4 {
                        holdCount += 0.1
                    } else {
                        vibe.toggle()
                        status = .exhale
                        holdCount = 0
                    }
                } else if status == .exhale {
                    withAnimation {
                        counter = Int(count.rounded())
                    }

                    if count > 0 {
                        withAnimation {
                            count -= 0.1
                        }
                    } else {
                        vibe.toggle()
                        status = .holdExhale
                        count = 0
                    }
                } else {
                    withAnimation {
                        counter = Int(holdCount.rounded())
                    }

                    if holdCount < 4 {
                        holdCount += 0.1
                    } else {
                        vibe.toggle()
                        status = .inhale
                        holdCount = 0
                        withAnimation {
                            round += 1
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            #if os(iOS)
            UIApplication.shared.isIdleTimerDisabled = true
            #endif
        })
        .onDisappear(perform: {
            #if os(iOS)
            UIApplication.shared.isIdleTimerDisabled = false
            #endif
        })
        .sheet(isPresented: $showingSheet, content: {
            BreathDoneSheet(healthKitController: healthKitController, date: date, elapsed: elapsed, type: $type, rounds: $rounds, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingMainSheet: $showingMainSheet)
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
        })
    }

    func timerStopped() {
        if isTimerRunning {
            showingSheet.toggle()
            stopTimer()
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
    BoxingView(healthKitController: HealthKitController(), type: .constant(.box), rounds: .constant(20), mood: .constant(.neutral), showingMainSheet: .constant(true))
}

