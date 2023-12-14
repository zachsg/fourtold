//
//  MeditateTimerView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/11/23.
//

import AVFoundation
import SwiftUI
import UIKit

struct MeditateTimerView: View {
    @Binding var meditationType: FTMeditateType
    @Binding var meditateGoal: Int
    @Binding var showingAlert: Bool
    @Binding var elapsed: TimeInterval
    
    @State var isTimerRunning = true
    @State private var startTime =  Date()
    @State private var timerString = "..."
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var progress: CGFloat {
        CGFloat(elapsed) / CGFloat(meditateGoal)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(Circle().stroke(.secondary.opacity(0.2), lineWidth: 25))
            
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(Circle()
                    .trim(from:0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: 0.2)
                )
            
            VStack {
                Text(timerString)
                    .font(Font.system(.title, design: .monospaced))
                    .padding()
                    .onReceive(timer) { _ in
                        if isTimerRunning {
                            elapsed = Date().timeIntervalSince(startTime)
                            
                            let elapsedTemp = meditationType == .open ? Date().timeIntervalSince(startTime) : Double(meditateGoal) - Date().timeIntervalSince(startTime)
                            
                            let tempTimerString = elapsedTemp.secondsAsTime(units: .short)
                            timerString = tempTimerString.replacingOccurrences(of: ", ", with: "\n")
                            
                            if meditationType == .timed {
                                if elapsedTemp < 0 {
                                    stopTimer()
                                    showingAlert.toggle()
                                    AudioServicesPlaySystemSound(1007)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        timerStopped()
                    }
                    .onAppear(perform: {
                        UIApplication.shared.isIdleTimerDisabled = true
                    })
                    .onDisappear(perform: {
                        UIApplication.shared.isIdleTimerDisabled = false
                })
                
                Text("Tap to end")
                    .font(.footnote)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            Button("Cancel", systemImage: cancelSystemImage) {
                timerStopped()
            }
        }
        .onAppear(perform: {
            if meditationType == .timed {
                NotificationController.scheduleNotification(title: "Meditation Done", subtitle: "You completed your mediation goal.", timeInSeconds: meditateGoal)
            }
        })
    }
    
    func timerStopped() {
        if isTimerRunning {
            showingAlert.toggle()
            stopTimer()
        } else {
            timerString = "0.00"
            startTime = Date()
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
    MeditateTimerView(meditationType: .constant(.timed), meditateGoal: .constant(300), showingAlert: .constant(false), elapsed: .constant(0))
}
