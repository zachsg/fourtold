//
//  TimerView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/15/23.
//

import AVFoundation
import SwiftUI
import UIKit

struct TimerView: View {
    @Binding var goal: Int
    @Binding var showingAlert: Bool
    @Binding var elapsed: TimeInterval
    
    var color: Color
    var isTimed: Bool
    var notificationTitle: String
    var notificationSubtitle: String
    
    @State var isTimerRunning = true
    @State private var startTime =  Date()
    @State private var timerString = "..."
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var progress: CGFloat {
        CGFloat(elapsed) / CGFloat(goal)
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
                    .foregroundColor(color)
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
                            
                            let elapsedTemp = isTimed ? Double(goal) - Date().timeIntervalSince(startTime) : Date().timeIntervalSince(startTime)
                            
                            let tempTimerString = elapsedTemp.secondsAsTime(units: .short)
                            timerString = tempTimerString.replacingOccurrences(of: ", ", with: "\n")
                            
                            if isTimed {
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
            Button(action: {
                timerStopped()
            }, label: {
                Label(
                    title: {
                        Text("Cancel")
                            .foregroundStyle(color)
                    },
                    icon: {
                        Image(systemName: cancelSystemImage)
                            .foregroundStyle(color)
                    }
                )
            })
        }
        .onAppear(perform: {
            if isTimed {
                NotificationController.scheduleNotification(title: notificationTitle, subtitle: notificationSubtitle, timeInSeconds: goal)
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
    TimerView(goal: .constant(300), showingAlert: .constant(false), elapsed: .constant(60), color: .red, isTimed: true, notificationTitle: "Finished", notificationSubtitle: "You are finished")
}
