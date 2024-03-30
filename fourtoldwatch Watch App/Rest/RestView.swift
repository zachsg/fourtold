//
//  RestView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct RestView: View {
    @Bindable var healthKitController: HealthKitController

    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    @Query(sort: \FTBreath.startDate) var breaths: [FTBreath]

    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false

    @State private var path = NavigationPath()

    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []

        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        let todayBreaths = breaths.filter { isToday(date: $0.startDate) }

        activities.append(contentsOf: todayMeditates)
        activities.append(contentsOf: todayReads)
        activities.append(contentsOf: todayBreaths)

        return activities.sorted { $0.startDate > $1.startDate }
    }

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    HStack {
                        Button {
                            path.append(RestOption.breathe)
                        } label: {
                            Image(systemName: breathSystemImage)
                        }

                        Button {
                            path.append(RestOption.meditate)
                        } label: {
                            Image(systemName: meditateSystemImage)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .listRowBackground(Color.clear)

                if !todayActivities.isEmpty {
                    Section("Activities today") {
                        ForEach(todayActivities, id: \.id) { activity in
                            RestItemView(activity: activity)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let activity = todayActivities[index]
                                modelContext.delete(activity)
                            }
                        }
                    }
                } else {
                    Section {
                        HStack {
                            Text("It's a new day.\nTake action!")
                            Image(systemName: arrowSystemImage)
                                .rotationEffect(.degrees(-90))
                                .foregroundStyle(.rest)
                                .font(.title3)
                        }
                        .font(.headline)
                    }
                }
            }
            .navigationDestination(for: RestOption.self) { option in
                if option == .meditate {
                    MeditateSetup(healthKitController: healthKitController, path: $path)
                } else if option == .breathe {
                    BreatheSetup(healthKitController: healthKitController, path: $path)
                }
            }
        }
        .tint(.rest)
    }

    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    RestView(healthKitController: HealthKitController())
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
