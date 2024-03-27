//
//  MeditateDuring.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI
import WatchConnectivity

class WKDelegate: NSObject, WKExtendedRuntimeSessionDelegate{
    // MARK:- Extended Runtime Session Delegate Methods
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Track when your session starts.
    }


    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // Finish and clean up any tasks before the session ends.
    }

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // Track when your session ends.
        // Also handle errors here.
    }
}

struct MeditateDuring: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var healthKitController: HealthKitController

    @Binding var meditateType: FTMeditateType
    @Binding var meditateGoal: Int
    @Binding var startDate: Date
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var elapsed: TimeInterval
    @Binding var path: NavigationPath

    @State private var session = WKExtendedRuntimeSession()
    @State var delegate = WKDelegate()

    var body: some View {
        VStack {
            TimerView(path: $path, goal: $meditateGoal, elapsed: $elapsed, color: .rest, isTimed: meditateType == .timed, notificationTitle: "Meditation Done", notificationSubtitle: "You completed your mediation goal.")
        }
        .onAppear(perform: {
            startDate = .now
            endMood = mood
            session.delegate = delegate
            session.start()
        })
        .navigationDestination(for: RestOption.self) { option in
            if option == .meditateDone {
                MeditateDone(healthKitController: healthKitController, type: $meditateType, startDate: $startDate, elapsed: $elapsed, goal: $meditateGoal, mood: $mood, endMood: $endMood, path: $path)
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()

    return MeditateDuring(healthKitController: healthKitController, meditateType: .constant(.timed), meditateGoal: .constant(300), startDate: .constant(.now), mood: .constant(.neutral), endMood: .constant(.neutral), elapsed: .constant(0), path: .constant(NavigationPath()))
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
