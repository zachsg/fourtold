//
//  Four78ingView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct Four78ingView: View {
    @Environment(HealthKitController.self) private var healthKitController
    
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
        .navigationTitle("4-7-8 Breathing")
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
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .onDisappear(perform: {
            UIApplication.shared.isIdleTimerDisabled = false
        })
        .sheet(isPresented: $showingSheet, content: {
            BreathDoneSheet(date: date, elapsed: elapsed, type: $type, rounds: $rounds, mood: $mood, endMood: $endMood, showingSheet: $showingSheet, showingMainSheet: $showingMainSheet)
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
    let healthKitController = HealthKitController()
    
    return Four78ingView(type: .constant(.four78), rounds: .constant(4), mood: .constant(.neutral), showingMainSheet: .constant(true))
        .environment(healthKitController)
}
