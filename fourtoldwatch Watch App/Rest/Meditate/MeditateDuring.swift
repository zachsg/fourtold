//
//  MeditateDuring.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct MeditateDuring: View {
    @Environment(\.modelContext) var modelContext
    @Environment(HealthKitController.self) private var healthKitController

    @Binding var meditateType: FTMeditateType
    @Binding var meditateGoal: Int
    @Binding var startDate: Date
    @Binding var mood: FTMood
    @Binding var endMood: FTMood
    @Binding var elapsed: TimeInterval
    @Binding var path: NavigationPath

    @State private var session = WKExtendedRuntimeSession()
    @State private var delegate = WKDelegate()

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
    }
}

#Preview {
    let healthKitController = HealthKitController()

    return MeditateDuring(meditateType: .constant(.timed), meditateGoal: .constant(300), startDate: .constant(.now), mood: .constant(.neutral), endMood: .constant(.neutral), elapsed: .constant(0), path: .constant(NavigationPath()))
        .environment(healthKitController)
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
