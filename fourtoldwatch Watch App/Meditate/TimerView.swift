//
//  TimerView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import AVFoundation
import SwiftUI
import UIKit

struct TimerView: View {
    @Binding var path: NavigationPath
    @Binding var goal: Int
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
                .scaledToFit()
                .overlay(Circle().stroke(.secondary.opacity(0.2), lineWidth: 25))

            Circle()
                .fill(Color.clear)
                .scaledToFit()
                .overlay(Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(color)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: 0.2)
                )

            VStack {
                Text(timerString)
                    .font(Font.system(.title3, design: .monospaced))
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
                                    path.append(RestOption.meditateDone)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        timerStopped()
                    }
                Text("Tap to end")
                    .font(.footnote)
            }
        }
        .onAppear(perform: {
            if isTimed {
                NotificationController.scheduleNotification(title: notificationTitle, subtitle: notificationSubtitle, timeInSeconds: goal)
            }
        })
    }

    func timerStopped() {
        if isTimerRunning {
            stopTimer()
            path.append(MeditateStatus.done)
//            NavigationLink("blah", value: MeditateStatus.done)
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
    TimerView(path: .constant(NavigationPath()), goal: .constant(300), elapsed: .constant(60), color: .red, isTimed: true, notificationTitle: "Finished", notificationSubtitle: "You are finished")
}
