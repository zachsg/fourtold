//
//  RestView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftData
import SwiftUI

struct RestView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Bindable var healthKitController: HealthKitController
        
    @Environment(\.modelContext) var modelContext    
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    
    @State private var path = NavigationPath()
    
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    @State private var sunSheetIsShowing = false
    @State private var groundSheetIsShowing = false
    
    @State private var showOldActivities = false
    
    @State private var lastDate: Date = .now
    
    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        
        activities.append(contentsOf: todayMeditates)
        activities.append(contentsOf: todayReads)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var olderActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let olderMeditates = meditates.filter { !isToday(date: $0.startDate) }
        let olderReads = reads.filter { !isToday(date: $0.startDate) }
        
        activities.append(contentsOf: olderMeditates)
        activities.append(contentsOf: olderReads)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var bestMindfulDay: (day: Date, minutes: Int) {
        var bestDay: Date = .now
        var bestMinutes = 0
        
        for (day, minutes) in healthKitController.mindfulMinutesWeekByDay {
            if minutes > bestMinutes {
                bestDay = day
                bestMinutes = minutes
            }
        }
        
        return (bestDay, bestMinutes)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    RestMindfulMinutesToday(healthKitController: healthKitController)
                    
                    RestMindfulMinutesPastWeek(healthKitController: healthKitController)
                } header: {
                    Text("Stats")
                } footer: {
                    if bestMindfulDay.minutes > 0 {
                        HStack(spacing: 0) {
                            Text("Your best day was ")
                            Text(bestMindfulDay.day, format: .dateTime.weekday().month().day())
                            Text(" with \(bestMindfulDay.minutes) minutes.")
                        }
                    }
                }
                
                if !todayActivities.isEmpty {
                    Section("Today") {
                        ForEach(todayActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                RestMeditateItemView(meditate: meditate)
                            } else if let read = activity as? FTRead {
                                RestReadItemView(read: read)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let activity = todayActivities[index]
                                modelContext.delete(activity)
                            }
                        }
                    }
                } else {
                    HStack {
                        Text("It's a new day. Time to take action!")
                        Image(systemName: arrowSystemImage)
                            .rotationEffect(.degrees(-90))
                            .foregroundColor(restColor)
                            .font(.title3)
                    }
                    .font(.headline)
                }
                
                if !olderActivities.isEmpty {
                    Section(isExpanded: $showOldActivities) {
                        ForEach(olderActivities, id: \.id) { activity in
                            if let meditate = activity as? FTMeditate {
                                RestMeditateItemView(meditate: meditate)
                            } else if let read = activity as? FTRead {
                                RestReadItemView(read: read)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let activity = olderActivities[index]
                                modelContext.delete(activity)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Older")
                            Spacer()
                            Text(olderActivities.count, format: .number)
                                .font(.footnote)
                            Button {
                                withAnimation {
                                    showOldActivities.toggle()
                                }
                            } label: {
                                Image(systemName: showOldActivities ? "chevron.down.circle" : "chevron.forward.circle")
                                    .foregroundStyle(restColor)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle(restTitle)
            .toolbar {
                ToolbarItemGroup(placement: .status) {
                    Button(readTitle, systemImage: readSystemImage) {
                        readSheetIsShowing.toggle()
                    }
                    .foregroundStyle(restColor)
                    
                    Button(journalTitle, systemImage: journalSystemImage) {
                        journalSheetIsShowing.toggle()
                    }
                    .foregroundStyle(restColor)
                    
                    Button(breathTitle, systemImage: breathSystemImage) {
                        breathworkSheetIsShowing.toggle()
                        // TODO: Add breathwork
                    }
                    .foregroundStyle(restColor)
                    
                    Button(meditateTitle, systemImage: meditateSystemImage) {
                        meditateSheetIsShowing.toggle()
                    }
                    .foregroundStyle(restColor)
                    
                    Button(sunTitle, systemImage: sunSystemImage) {
                        sunSheetIsShowing.toggle()
                    }
                    .foregroundStyle(restColor)
                    
                    Button(groundTitle, systemImage: groundSystemImage) {
                        groundSheetIsShowing.toggle()
                    }
                    .foregroundStyle(restColor)
                }
            }
            .sheet(isPresented: $readSheetIsShowing) {
                ReadSheet(healthKitController: healthKitController, showingSheet: $readSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $journalSheetIsShowing) {
                JournalSheet()
            }
            .sheet(isPresented: $breathworkSheetIsShowing) {
                BreathSheet(healthKitController: healthKitController, showingSheet: $breathworkSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $meditateSheetIsShowing) {
                MeditationsSheet(healthKitController: healthKitController, showingSheet: $meditateSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $sunSheetIsShowing) {
                Text("Sunning sheet")
            }
            .sheet(isPresented: $groundSheetIsShowing) {
                Text("Grounding sheet")
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                if !Calendar.current.isDateInToday(lastDate) {
                    lastDate = .now
                    showOldActivities.toggle()
                    showOldActivities = false
                }
            }
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return RestView(healthKitController: healthKitController)
        .modelContainer(for: [FTMeditate.self, FTRead.self])
}
